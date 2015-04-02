local MAJOR, MINOR = "LibLuminary", 1
local LibLuminary, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibLuminary then return end --the same or newer version of self lib is already loaded into memory

--LibLuminary.config = {}

local ListView = {}



--- just because I do this frequently... lol
function LibLuminary:new(config)
    assert(1 ~= 1, "You need to use function New not lowercase new")
end

--- just because I do this frequently... lol
function LibLuminary:init(config)
    assert(1 ~= 1, "You need to use function New not lowercase init")
end


function LibLuminary:New(config)
    local settings = config
    self.config = config.config or {}
    self.config.width = config.width or 300
    self.config.height = config.height or 50
    self.config.anchorTargetControl = config.anchorTargetControl
    self.config.animationTime = config.animationTime or DEFAULT_SCENE_TRANSITION_TIME;
    self.config.offsetX = config.x or LEFT
    self.config.offsetY = config.y or RIGHT
    self.config.top = config.top or TOP
    self.wm = GetWindowManager()

    self.config.addonName = config.addonName
    self.line_height = settings.line_height or 20
    self.slider_texture = settings.slider_texture or "/esoui/art/miscellaneous/scrollbox_elevator.dds"
    self.title = settings.title -- can be nil

    self.control = config.anchorTargetControl
    self.name = self.control:GetName()

    self.offset = 0
    self.lines = {}
    self.currently_resizing = false
    self.TITLE_HEIGHT = 24
    self.LINES_OFFSET = self.TITLE_HEIGHT
    self.SLIDER_WIDTH = 22

    self.settings = config.settings or {}

    -- Not storing these in self; use self.control:GetWidth() and self.control:GetHeight()
    self.width = config.settings.width or 400
    self.height = config.settings.height or 400
    local left = config.settings.left or 100
    local top = config.settings.top or 100



    -- TODO: Translate self:SetHidden() etc. to self.control:SetHidden()
    setmetatable(self, { __index = ListView })
    assert(self.width ~= nil and self.height ~= nil, "Width and height cannot be nil")

    LibLuminary:initialize_listview(self, self.width, self.height, left, top)
    --    LibLuminary.CreateControl(self)

    return self
end


-- Utility
local function clamp(val, min_, max_)
    val = math.max(val, min_)
    return math.min(val, max_)
end


local BufferTable = {}
local function throttle(key, buffer)
    if key == nil then return end
    if BufferTable[key] == nil then BufferTable[key] = {} end

    BufferTable[key].buffer = buffer or 15
    BufferTable[key].now = GetFrameTimeSeconds()
    if BufferTable[key].last == nil then BufferTable[key].last = BufferTable[key].now end
    BufferTable[key].diff = BufferTable[key].now - BufferTable[key].last
    BufferTable[key].eval = BufferTable[key].diff >= BufferTable[key].buffer
    if BufferTable[key].eval then BufferTable[key].last = BufferTable[key].now end
    return BufferTable[key].eval
end




-- Private API
function LibLuminary:set_line_counts()
    self.num_visible_lines = math.floor((self.control:GetHeight() - self.LINES_OFFSET) / self.line_height)
    self.num_visible_lines = math.min(self.num_visible_lines, #self.lines)

    self.num_hidden_lines = math.max(0, #self.lines - self.num_visible_lines)
    if self.num_hidden_lines == 0 then
        self.offset = 0
    end
end

function LibLuminary:create_listview_row(self,i)
    local control = self.control
    local name = self.name .. "_Line" .. i

    local line = self.wm:CreateControl(name, control, CT_CONTROL)
    line:SetHeight(self.line_height)

    line.text = self.wm:CreateControl(name .. "_Text", line, CT_LABEL)
    line.text:SetFont("ZoFontGame")
    line.text:SetColor(255, 255, 255, 1)
    line.text:SetText("")
    line.text:SetAnchorFill(line)

    return line
end

function LibLuminary:create_listview_lines_if_needed()
    local control = self.control

    -- Makes sure that the main control is filled up with line controls at all times.
    for i = 1, self.num_visible_lines do
        if control.lines[i] == nil then
            local line = LibLuminary:create_listview_row(self, i)
            control.lines[i] = line
            if i == 1 then
                line:SetAnchor(TOPLEFT, control, TOPLEFT, 0, self.LINES_OFFSET)
            else
                line:SetAnchor(TOPLEFT, control.lines[i - 1], BOTTOMLEFT, 0, 0)
            end
        end
    end
end

function LibLuminary:on_resize()
    local control = self.control

    -- Need to calculate num_visible_lines etc. for the rest of this function.
    LibLuminary:set_line_counts(self)

    LibLuminary:create_listview_lines_if_needed(self)

    -- Represent how many lines are visible atm.
    local viewable_lines_pct = self.num_visible_lines / #self.lines

    -- Can we see all the lines?
    if viewable_lines_pct >= 1.0 then
        control.slider:SetHidden(true)
    else
        -- If not, make sure the slider is showing.
        control.slider:SetHidden(false)
        self.control.slider:SetMinMax(0, self.num_hidden_lines)
        control.slider:SetHeight(control:GetHeight() - self.LINES_OFFSET)

        -- The more lines we can see, the bigger the slider should be.
        local tex = self.slider_texture
        -- TODO: I have no idea why I need to do "+ 8" to get it to fit here.. GOD I hate low level UI API's.
        control.slider:SetThumbTexture(tex, tex, tex, self.SLIDER_WIDTH + 8, control.slider:GetHeight() * viewable_lines_pct, 0, 0, 1, 1)
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

function LibLuminary:initialize_listview(width, height, left, top)
    local control = self.control
    local name = self.name

    -- control
    control:SetDimensions(self.width, self.height)
    control:SetHidden(false)
    control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
    control:SetMovable(true)
    control:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)
    control:SetMouseEnabled(true)
    control:SetClampedToScreen(true)

    -- control backdrop
    control.bd = self.wm:CreateControl(name .. "_Backdrop", control, CT_BACKDROP)
    control.bd:SetCenterColor(0, 0, 0, 0.6)
    control.bd:SetEdgeColor(0, 0, 0, 0)
    control.bd:SetAnchorFill(control)

    -- title
    if self.title then
        control.title = self.wm:CreateControl(name .. "_Title", control, CT_LABEL)
        control.title:SetFont("ZoFontGame")
        control.title:SetColor(255, 255, 255, 1)
        control.title:SetText("  " .. self.title)
        control.title:SetHeight(self.TITLE_HEIGHT)
        control.title:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
        control.title:SetAnchor(TOPRIGHT, control, TOPRIGHT, 0, 0)

        -- title backdrop
        control.title.bd = self.wm:CreateControl(name .. "_Title_Backdrop", control.title, CT_BACKDROP)
        control.title.bd:SetCenterColor(0, 0, 0, 0.7)
        control.title.bd:SetEdgeColor(0, 0, 0, 0)
        control.title.bd:SetAnchorFill(control.title)
    end

    -- close button
    control.close = self.wm:CreateControl(name .. "_Close", control, CT_BUTTON)
    control.close:SetDimensions(20, self.TITLE_HEIGHT)
    control.close:SetAnchor(TOPRIGHT, control, TOPRIGHT, 0, 0)
    control.close:SetFont("ZoFontGame")
    control.close:SetText("X")

    -- close backdrop
    control.close.bd = self.wm:CreateControl(name .. "_Close_Backdrop", control.close, CT_BACKDROP)
    control.close.bd:SetCenterColor(0, 0, 0, 1)
    control.close.bd:SetEdgeColor(0, 0, 0, 0)
    control.close.bd:SetAnchorFill(control.close)

    -- slider
    local tex = self.slider_texture
    control.slider = self.wm:CreateControl(name .. "_Slider", control, CT_SLIDER)
    control.slider:SetWidth(self.SLIDER_WIDTH)
    control.slider:SetMouseEnabled(true)
    control.slider:SetValue(0)
    control.slider:SetValueStep(1)
    control.slider:SetAnchor(TOPRIGHT, control.close, BOTTOMRIGHT, 0, 0)

    -- lines
    control.lines = {}
    LibLuminary:on_resize(self) -- sets important datastructures
    LibLuminary:create_listview_lines_if_needed(self)

    local me = self

    -- event: close button
    control.close:SetHandler("OnClicked", function(self, but)
        control:SetHidden(true)
    end)

    -- event: mwheel
    control:SetHandler("OnMouseWheel", function(self, delta)
        me.offset = clamp(me.offset - delta, 0, me.num_hidden_lines)
        control.slider:SetValue(me.offset)
    end)

    -- event: slider
    control.slider:SetHandler("OnValueChanged", function(self, val, eventReason)
        me.offset = clamp(val, 0, me.num_hidden_lines)
        me:ListViewUpdate()
    end)

    -- event: resize
    control:SetHandler("OnResizeStart", function(self)
        me.currently_resizing = true
    end)

    control:SetHandler("OnResizeStop", function(self)
        me.currently_resizing = false
        LibLuminary:on_resize(me)
    end)

    -- event: control update
    control:SetHandler("OnUpdate", function(self, elapsed)
        me:ListViewUpdate()
    end)
end

-- ListView, public API
function LibLuminary:ListViewUpdate()
    if throttle(self, 1) then
        return
    end

    if self.currently_resizing then
        LibLuminary:on_resize(self)
    end


    -- Goes through each line control and either shows a message or hides it.
    for i, line in pairs(self.control.lines) do
        local message = self.lines[i + self.offset] -- self.offset = how much we've scrolled down
--        d("here")
--        d()
        -- Only show messages that will be displayed within the control.
        if message ~= nil and i <= self.num_visible_lines then
            line.text:SetText(self.lines[i + self.offset])
            line:SetHidden(false)
        else
            line:SetHidden(true)
        end
    end
end

function LibLuminary:ListViewClear()
    self.lines = {}
    self:ListViewUpdate()
end

function LibLuminary:ListViewAdd_message(message)
    table.insert(self.lines, " " .. message) -- poor man's padding. for now.
    LibLuminary:on_resize(self) -- maybe the function needs a better name :)
end
