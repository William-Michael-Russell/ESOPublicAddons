local wm = WINDOW_MANAGER

local TITLE_HEIGHT = 45
local LINES_OFFSET = TITLE_HEIGHT
local SLIDER_WIDTH = 22
local SI = Teleporter.SI
-- Make self available to everything in this file
local self = {}
local mColor = {}
local controlWidth = 0
local counter = 1
local timerCounter = 1
local shouldTheyTeleport = false
local totalPortals = 0

-- Utility

local function clamp(val, min_, max_)
    val = math.max(val, min_)
    return math.min(val, max_)
end

local function round(x)
    if x % 2 ~= 0.5 then
        return math.floor(x + 0.5)
    end
    return x - 0.5
end


function Teleporter.FastPortalToPlayer(bool)
    d(SI.get(SI.TELEREFRESH))
    self.lines = {}

    Teleporter.CheckGuildMemeberStatus(1)
    totalPortals = #self.lines
    self:update()
end

local function normalTextureForAutoPlease()
    Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/group_pin.dds")
end

function Teleporter.AutoTeleportWithoutCir(bool)

    if not shouldTheyTeleport then
        self.lines = {}
        Teleporter.CheckGuildMemeberStatus(2)
        totalPortals = #self.lines
        self:update()
        d(SI.get(SI.TELE_PORT_IN_SEC) .. mTeleSavedVars.AutoPortFreq .. " secs")
        d(SI.get(SI.TELE_PUT_ON_FULL_SET_EXPLOATION_GEAR))
        d(Teleporter.var.color.colRed .. SI.get(SI.TELE_AGAIN_DISABLE))
        Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/follower_pin.dds")

        shouldTheyTeleport = true

    elseif shouldTheyTeleport then
        d(SI.get(SI.TELE_PORTAL_DISABLED))
        Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/hostile_pin.dds")
        zo_callLater(function() normalTextureForAutoPlease() end, 2000)
        shouldTheyTeleport = false
        counter = 1
        timerCounter = 0
        Teleporter.win.Main_Control.FPSCounter:SetText("")
    end
end


function TeleporterOnUpdate(bool)
    if shouldTheyTeleport then
        if BufferReached("AlertAsLikeAFPSTypeCounterLOL", 1) then
            timerCounter = timerCounter + 1

            timeUntilPortal = mTeleSavedVars.AutoPortFreq - timerCounter
            Teleporter.win.Main_Control.FPSCounter:SetText("Teleport in: " .. timeUntilPortal .. " secs")

            if timeUntilPortal == 40 then
                d(SI.get(SI.TELE_TELE) .. " " .. timeUntilPortal .. " secs")
            end

            if timeUntilPortal == 25 then
                d(SI.get(SI.TELE_TELE) .. " " .. timeUntilPortal .. " secs")
            end

            if timeUntilPortal == 10 then
                d(SI.get(SI.TELE_TELE) .. " " .. timeUntilPortal .. " secs")
            end

            if timeUntilPortal == 5 then
                d(SI.get(SI.TELE_IN_FIVE_SEC))
            end
            if timerCounter >= 45 then
                timerCounter = 0
            end
        end


        if BufferReached("PortalEveryThirtySeconds", mTeleSavedVars.AutoPortFreq) then
            local portal = self.lines[counter]
            d(SI.get(SI.TELE_TO_PLAYER) .. portal.GuildMember)
            JumpToGuildMember(portal.GuildMember)
            counter = counter + 1

            if counter >= totalPortals then
                counter = 1
                shouldTheyTeleport = false
                Teleporter.win.Main_Control.FPSCounter:SetText("")
            end
        end
    end
end

----------------------------------------------------
--- Function to Portal to Guild Members
-----------------------------------------------------
local function PortalToPlayer(string)
    --First check if YOU have permissions to remove players.
    JumpToGuildMember(string)
    d(SI.get(SI.TELE_TO_PLAYER) .. string)
end

-- Private API
local function _set_line_counts(self)
    self.num_visible_lines = math.floor((self.control:GetHeight() - LINES_OFFSET) / self.line_height)
    self.num_visible_lines = math.min(self.num_visible_lines, #self.lines)

    self.num_hidden_lines = math.max(0, #self.lines - self.num_visible_lines)
    if self.num_hidden_lines == 0 then
        self.offset = 0
    end
end

local function _create_listview_row(self, i)
    local control = self.control
    local name = control:GetName() .. "_list" .. i


    local list = wm:CreateControl(name, control, CT_CONTROL)
    list:SetHeight(self.line_height)

    local message = self.lines[i]

    if message ~= nil then
        table.sort(message, function(a, b) return a.zoneName < b.zoneName end)
        if message.GuildMember ~= nil then
            list.GuildMember = wm:CreateControl(name .. "_Player", list, CT_LABEL)
            list.GuildMember:SetDimensions(120, 20)
            list.GuildMember:SetFont("ZoFontGame")
            list.GuildMember:SetColor(255, 255, 255, 1)
            list.GuildMember:SetAnchor(0, list, 0, LEFT, 20)
        end


        if message.level ~= nil then
            list.level = wm:CreateControl(name .. "_PlayerLevel", list, CT_LABEL)
            list.level:SetDimensions(20, 22)
            list.level:SetFont("ZoFontGame")
            list.level:SetColor(255, 255, 255, 1)
            list.level:SetAnchor(0, list, 0, LEFT + 175, 20)
        end


        ----------------------------------------------------------

        -- if message.veteranRank >= 1 then
        list.vetText = WINDOW_MANAGER:CreateControl(nil, list, CT_TEXTURE)
        list.vetText:SetDimensions(30, 30)
        list.vetText:SetAnchor(0, list, nil, LEFT + 145, 18)
        list.vetText:SetTextureCoords(0, 1, 0, 1)
        list.vetText:SetAlpha(1)
        list.vetText:SetTexture("/Teleporter/media/target_veteranrank_icon.dds") --/Teleporter/media/target_veteranrank_icon.dds
        list.vetText:SetDrawLayer(0)
        list.vetText:SetDrawLayer(2)
        list.vetText:SetDrawTier(1)

        --  end
        ----------------------------


        controlWidth = control:GetWidth()


        list.frame = wm:CreateControl(nil, list, CT_TEXTURE)
        list.frame:SetDimensions(controlWidth - 5, 3)
        list.frame:SetAnchor(0, list, 0, LEFT, 15)

        list.frame:SetTexture("/esoui/art/guild/sectiondivider_left.dds")
        list.frame:SetTextureCoords(0, 1, 0, 1)
        list.frame:SetAlpha(0.7)


        if message.zoneName ~= nil then
            list.zoneName = wm:CreateControl(name .. "_Zone", list, CT_LABEL)
            list.zoneName:SetDimensions(200, 20)
            list.zoneName:SetFont("ZoFontGame")
            list.zoneName:SetColor(255, 255, 255, 1)
            list.zoneName:SetAnchor(0, list, 0, LEFT + 240, 20)
        end

        --        /Teleporter/media/travel_wayshrine_currentloc.dds  /Teleporter/media/travel_wayshrine.dds
        if message.zoneName ~= nil then
            list.portalToPlayerTex = WINDOW_MANAGER:CreateControl(nil, list, CT_TEXTURE)
            list.portalToPlayerTex:SetDimensions(40, 40)
            list.portalToPlayerTex:SetAnchor(0, list, 0, LEFT + 420, 15)
            -- lthline.frame:SetAnchor(0, lthline, 0, LEFT, 20)

            list.portalToPlayerTex:SetTextureCoords(0, 1, 0, 1)
            list.portalToPlayerTex:SetAlpha(1)


            list.portalToPlayer = wm:CreateControl(name .. "Portal", list.portalToPlayerTex, CT_BUTTON)
            list.portalToPlayer:SetFont("ZoFontGame")


            list.portalToPlayer:SetAnchorFill(list.portalToPlayerTex)
            list.portalToPlayer:SetHandler("OnClicked", function() PortalToPlayer(message.GuildMember) end)
            list.portalToPlayer:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture("/Teleporter/media/wayshrine.dds") end)
            list.portalToPlayer:SetHandler("OnMouseExit", function(self)
                if message.zoneName == GetUnitZone("player") then
                    list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine.dds")
                else
                    list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine_currentloc.dds")
                end
            end)
        end

        ------- TODO, wwhy did you make such a mess here.... CLEAN THIS SHIT UP.

        if message.zoneName ~= nil then
            if message.zoneName == GetUnitZone("player") then

                if message.veteranRank >= 1 then
                    list.vetText:SetAlpha(1)
                    list.vetText:SetTexture("/Teleporter/media/target_veteranrank_icon.dds")
                    list.level:SetText(Teleporter.var.color.colArcane .. message.veteranRank)
                else
                    list.vetText:SetAlpha(0)
                    list.level:SetText(Teleporter.var.color.colArcane .. message.level)
                end


                -- list.veteranRank:SetText(Teleporter.var.color.colArcane .. message.veteranRank)
                list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine.dds")

                list.GuildMember:SetText(Teleporter.var.color.colArcane .. message.GuildMember)
                list.zoneName:SetText(Teleporter.var.color.colArcane .. message.zoneName)
            else

                if message.veteranRank >= 1 then --veteranRank
                    list.vetText:SetAlpha(1)
                    list.vetText:SetTexture("/Teleporter/media/target_veteranrank_icon.dds")
                    list.level:SetText(Teleporter.var.color.colArcane .. message.veteranRank)
                else
                    list.vetText:SetAlpha(0)
                    list.level:SetText(Teleporter.var.color.colArcane .. message.level)
                end


                -- list.level:SetText(Teleporter.var.color.colWhite .. message.level)
                --    list.veteranRank:SetText(Teleporter.var.color.colWhite .. message.veteranRank)
                list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine_currentloc.dds")
                list.GuildMember:SetText(Teleporter.var.color.colWhite .. message.GuildMember)
                list.zoneName:SetText(Teleporter.var.color.colWhite .. message.zoneName)
            end
        end

        return list
    end
end

local function _create_listview_lines_if_needed(self)
    local control = self.control

    -- Makes sure that the main control is filled up with line controls at all times.
    for i = 1, self.num_visible_lines do
        if control.lines[i] == nil then
            local line = _create_listview_row(self, i)
            control.lines[i] = line
            if i == 1 then
                line:SetAnchor(TOPLEFT, control, TOPLEFT, 0, LINES_OFFSET)
            else
                line:SetAnchor(TOPLEFT, control.lines[i - 1], BOTTOMLEFT, 0, 0)
            end
        end
    end
end

local function _on_resize(self)
    local control = self.control

    -- Need to calculate num_visible_lines etc. for the rest of this function.
    _set_line_counts(self)

    _create_listview_lines_if_needed(self)

    -- Represent how many lines are visible atm.
    local viewable_lines_pct = self.num_visible_lines / #self.lines

    -- Can we see all the lines?
    if viewable_lines_pct >= 1.0 then
        control.slider:SetHidden(true)
    else
        -- If not, make sure the slider is showing.
        control.slider:SetHidden(false)
        self.control.slider:SetMinMax(0, self.num_hidden_lines)
        control.slider:SetHeight(control:GetHeight() - LINES_OFFSET)

        -- The more lines we can see, the bigger the slider should be.
        local tex = self.slider_texture
        -- TODO: I have no idea why I need to do "+ 8" to get it to fit here.. GOD I hate low level UI API's.
        control.slider:SetThumbTexture(tex, tex, tex, SLIDER_WIDTH + 8, control.slider:GetHeight() * viewable_lines_pct, 0, 0, 1, 1)
    end

    -- Update line widths in case we just resized self.control.
    local line_width = control:GetWidth()
    if not control.slider:IsControlHidden() then

        line_width = line_width - control.slider:GetWidth()
    end

    for _, line in pairs(control.lines) do
        line:SetWidth(line_width)
    end
end

local function _initialize_listview(self, width, height, left, top)
    local control = self.control
    local name = control:GetName()

    -- control
    control:SetDimensions(width, height)
    control:SetHidden(true)
    if mTeleSavedVars.TH_x ~= nil then
        control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + mTeleSavedVars.TH_x, mTeleSavedVars.TH_y)
    else
        control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + 50, 150)
    end
    control:SetMovable(true)
    control:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)
    control:SetMouseEnabled(true)
    control:SetClampedToScreen(true)

    -- control backdrop
    control.bd = WINDOW_MANAGER:CreateControl(nil, control, CT_TEXTURE)
    control.bd:SetAnchor(CENTER, control, CENTER, TOPLEFT - 50, TOP + 50)
    control.bd:SetDimensions(control:GetWidth() + 100, control:GetHeight() + 200)
    control.bd:SetTexture("/esoui/art/miscellaneous/centerscreen_left.dds")
    control.bd:SetTextureCoords(0, 1, 0, 1)
    control.bd:SetAlpha(1)


    control.playertitle = wm:CreateControl(name .. "_PlayerTitle", control, CT_LABEL)
    control.playertitle:SetFont("ZoFontGame")
    control.playertitle:SetColor(255, 255, 255, 1)
    control.playertitle:SetText(SI.get(SI.TELE_PLAYER))
    --control.playertitle:tooltipText("Test")
    control.playertitle:SetAnchor(TOPLEFT, control, TOPLEFT, 25, -5)



    control.playertitle = wm:CreateControl(name .. "_LVL", control, CT_LABEL)
    control.playertitle:SetFont("ZoFontGame")
    control.playertitle:SetColor(255, 255, 255, 1)
    control.playertitle:SetText("LVL")
    control.playertitle:SetAnchor(TOPLEFT, control, TOPLEFT, 155, -5)


    ------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------

    control.playerzone = wm:CreateControl(name .. "_PlayerZone", control, CT_LABEL)
    control.playerzone:SetFont("ZoFontGame")
    control.playerzone:SetColor(255, 255, 255, 1)
    control.playerzone:SetText(SI.get(SI.TELE_ZONE))
    control.playerzone:SetAnchor(TOPLEFT, control, TOPLEFT, 235, -5)



    -- slider
    local tex = self.slider_texture
    control.slider = wm:CreateControl(name .. "_Slider", control, CT_SLIDER)
    control.slider:SetWidth(SLIDER_WIDTH)
    control.slider:SetMouseEnabled(true)
    control.slider:SetValue(0)
    control.slider:SetValueStep(1)
    control.slider:SetAnchor(TOPRIGHT, control, TOPRIGHT, 30, 0)

    -- lines
    control.lines = {}
    _on_resize(self) -- sets important datastructures
    _create_listview_lines_if_needed(self)

    local me = self

    -- event: mwheel
    control:SetHandler("OnMouseWheel", function(self, delta)
        me.offset = clamp(me.offset - delta, 0, me.num_hidden_lines)
        control.slider:SetValue(me.offset)
        me:update()
    end)

    -- event: slider
    control.slider:SetHandler("OnValueChanged", function(self, val, eventReason)
        me.offset = clamp(val, 0, me.num_hidden_lines - 1)
        me:update()
    end)

    -- event: resize
    control:SetHandler("OnResizeStart", function(self)
        me.currently_resizing = true
    end)

    control:SetHandler("OnResizeStop", function(self)
        me.currently_resizing = false
        _on_resize(me)
        me:update()
    end)

    -- event: control update
    control:SetHandler("OnUpdate", function(self, elapsed)
        me:update()
    end)

    -- event: control update
    control:SetHandler("OnMouseUp", function(self)
        mTeleSavedVars.TH_x = math.floor(Teleporter.win.Main_Control:GetLeft())
        mTeleSavedVars.TH_y = math.floor(Teleporter.win.Main_Control:GetTop())
    end)
end

-- ListView, public API

local ListView = {}

function ListView.new(control, name, settings)
    settings = settings or {}

    -- Not storing these in self; use self.control:GetWidth() and self.control:GetHeight()
    local width = 450
    local height = settings.height or 400
    local left = 30
    local top = 150

    self = {
        line_height = 40 or 35,
        slider_texture = settings.slider_texture or "/esoui/art/miscellaneous/scrollbox_elevator.dds",
        title = settings.title, -- can be nil

        control = control,
        name = control:GetName(),
        offset = 0,
        lines = {},
        currently_resizing = false,
    }

    -- TODO: Translate self:SetHidden() etc. to self.control:SetHidden()
    setmetatable(self, { __index = ListView })

    _initialize_listview(self, width, height, left, top)

    return self
end




--- - IM RIGHT HERE
function ListView:update()
    local throttle_time = self.currently_resizing and 0.02 or 0.1
    if TeleUnicorn.throttle(self, 0.05) then
        return
    end

    if self.currently_resizing then
        _on_resize(self)
    end

    -- Goes through each line control and either shows a message or hides it.
    for i, list in pairs(self.control.lines) do
        local message = self.lines[i + self.offset] -- self.offset = how much we've scrolled down

        -- Only show messages that will be displayed within the control.
        if message ~= nil and i <= self.num_visible_lines  then
            if i >= self.num_visible_lines + 1 then return end;
            if message == nil then return end;



            if message.zoneName == GetUnitZone("player") then
                --                /Teleporter/media/travel_wayshrine_currentloc.dds  /Teleporter/media/travel_wayshrine.dds

                if message.zoneName == nil then return end;

                if message.veteranRank >= 1 then
                    list.vetText:SetAlpha(1)
                    list.level:SetText(Teleporter.var.color.colArcane .. message.veteranRank)
                else
                    list.vetText:SetAlpha(0)
                    list.level:SetText(Teleporter.var.color.colArcane .. message.level)
                end

                list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine.dds")

                list.GuildMember:SetText(Teleporter.var.color.colArcane .. message.GuildMember)
                list.zoneName:SetText(Teleporter.var.color.colArcane .. message.zoneName)
                list.portalToPlayer:SetHandler("OnClicked", function() PortalToPlayer(message.GuildMember) end)
                list.portalToPlayer:SetHandler("OnMouseExit", function(self)
                    if message.zoneName == GetUnitZone("player") then
                        list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine.dds")
                    else
                        list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine_currentloc.dds")
                    end
                end)
            else
                if message.veteranRank == nil then return end;
                --              /Teleporter/media/travel_wayshrine.dds
                list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine_currentloc.dds")


                if message.veteranRank >= 1 then
                    list.vetText:SetTexture("/Teleporter/media/target_veteranrank_icon.dds")
                    list.level:SetText(Teleporter.var.color.colArcane .. message.veteranRank)
                    list.vetText:SetAlpha(1)
                else
                    list.vetText:SetAlpha(0)
                    list.level:SetText(Teleporter.var.color.colArcane .. message.level)
                end
                --        list.veteranRank:SetText(Teleporter.var.color.colWhite .. message.veteranRank)
                list.GuildMember:SetText(Teleporter.var.color.colWhite .. message.GuildMember)
                list.zoneName:SetText(Teleporter.var.color.colWhite .. message.zoneName)
                list.portalToPlayer:SetHandler("OnClicked", function() PortalToPlayer(message.GuildMember) end)
                list.portalToPlayer:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture("/Teleporter/media/wayshrine.dds") end)
                list.portalToPlayer:SetHandler("OnMouseExit", function(self)
                    if message.zoneName == GetUnitZone("player") then
                        list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine.dds")
                    else
                        list.portalToPlayerTex:SetTexture("/Teleporter/media/travel_wayshrine_currentloc.dds")
                    end
                end)
            end

            list:SetHidden(false)
        else
            list:SetHidden(true)
        end
    end
end

---------------------------
-- Refresh button from UI--
----------------------------
function RefreshGuildList()
    --m  d(SI.get(SI.TELEREFRESH))
    self.lines = {}

    Teleporter.CheckGuildMemeberStatus()
    totalPortals = #self.lines
    self:update()
end

function ListView:clear()
    ListView = {}
    self.lines = {}
    self:update()
end

function ListView:add_messages(message)
    self.lines = {}

        for k, v in pairs(message) do self.lines[k] = v
          table.insert(self.lines, message)
         end
    totalPortals = #self.lines
    LumListView = {}
    _on_resize(self) -- maybe the function needs a better name :)
    self:update()
end

TeleUnicorn.ListView = ListView



