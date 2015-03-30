local MAJOR, MINOR = "LibLuminary", 1
local LibLuminary, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibLuminary then return end --the same or newer version of self lib is already loaded into memory

LibLuminary.__index = LibLuminary

LibLuminary.config = {}
--local self = {}
--local _ = {}


function LibLuminary:init(config)

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
    --    LibLuminary.CreateControl(self)
    self.mainCControl = self:CreateMsgWindow(self)
    self.scrollList = self.mainCControl.list
    return self.mainCControl
end


local function AdjustSlider(self)
    local numHistoryLines = self:GetNamedChild("Buffer"):GetNumHistoryLines()
    local numVisHistoryLines = self:GetNamedChild("Buffer"):GetNumVisibleLines()
    local bufferScrollPos = self:GetNamedChild("Buffer"):GetScrollPosition()
    local sliderMin, sliderMax = self:GetNamedChild("Slider"):GetMinMax()
    local sliderValue = self:GetNamedChild("Slider"):GetValue()

    self:GetNamedChild("Slider"):SetMinMax(0, numHistoryLines)

    -- If the sliders at the bottom, stay at the bottom to show new text
    if sliderValue == sliderMax then
        self:GetNamedChild("Slider"):SetValue(numHistoryLines)
        -- If the buffer is full start moving the slider up
    elseif numHistoryLines == self:GetNamedChild("Buffer"):GetMaxHistoryLines() then
        self:GetNamedChild("Slider"):SetValue(sliderValue - 1)
    end -- Else the slider does not move

    -- If there are more history lines than visible lines show the slider
    if numHistoryLines > numVisHistoryLines then
        self:GetNamedChild("Slider"):SetHidden(false)
    else
        -- else hide the slider
        self:GetNamedChild("Slider"):SetHidden(true)
    end
end

function LibLuminary:CreateMsgWindow()
    -- Dimension Constraits
    local minWidth = self.config.width
    local minHeight = self.config.height

    local lltwl = WINDOW_MANAGER:CreateTopLevelWindow(self.config.addonName)
    lltwl:SetHidden(true)
    lltwl:SetMovable(true)
    lltwl:SetClampedToScreenInsets(-14)
    lltwl:SetMouseEnabled(true)
    lltwl:SetClampedToScreen(true)
    lltwl:SetDimensions(350, 400)
    lltwl:SetAnchor(CENTER, self.config.anchorTargetControl, CENTER, self.config.offsetX, self.config.offsetY)
    lltwl:SetDimensionConstraints(minWidth, minHeight)
    lltwl:SetResizeHandleSize(25)

    lltwl:SetHandler("OnShow", function()
       -- self.playerRank = GetUnitAvARank("player")
        local scrollList = LibLuminary.scrollList
       -- local scrollBar = scrollList.scrollbar
       -- local minValue, maxValue = scrollBar:GetMinMax()
       -- local centerValue = 1 * ROW_HEIGHT-(scrollList:GetHeight()/2)
       -- scrollBar:SetValue(centerValue)
    end)





    local bg = WINDOW_MANAGER:CreateControl(self.config.addonName .. "Bg", lltwl, CT_BACKDROP)
    bg:SetAnchor(TOPLEFT, lltwl, TOPLEFT, -8, -6)
    bg:SetAnchor(BOTTOMRIGHT, lltwl, BOTTOMRIGHT, 4, 4)
    bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
    bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    bg:SetInsets(32, 32, -32, -32)
    bg:SetDimensionConstraints(minWidth, minHeight)


    local divider = WINDOW_MANAGER:CreateControl(self.config.addonName .. "Divider", lltwl, CT_TEXTURE)
    divider:SetDimensions(4, 8)
    divider:SetAnchor(TOPLEFT, lltwl, TOPLEFT, 20, 40)
    divider:SetAnchor(TOPRIGHT, lltwl, TOPRIGHT, -20, 40)
    divider:SetTexture("EsoUI/Art/Miscellaneous/horizontalDivider.dds")
    divider:SetTextureCoords(0.181640625, 0.818359375, 0, 1)



    local list
    list = WINDOW_MANAGER:CreateControlFromVirtual(self.config.addonName .. "List", lltwl, "ZO_ScrollList")
    self.scrollList = list
    LibLuminary.scrollList = list
    list:SetAnchor(CENTER, lltwl, CENTER, -8, 10)
    list:SetHeight(minHeight)
    list:SetWidth(minWidth)
    list:SetHandler("OnMouseEnter", function(self, delta, ctrl, alt, shift)
        local offset = delta

        d (offset)
        if shift then
            offset = offset * buffer:GetNumVisibleLines()
        elseif ctrl then
            offset = offset * buffer:GetNumHistoryLines()
        end
    end)

    local i = 0
    local xOffset = 0
    local lastlabel
    local parent = AlchemistListScrollChild
    function lltwl:AddLabel(txt, messages)

        local function listRow_Setup(rowControl, data, list)
            d("hello")
            rowControl:SetHeight(50)
            rowControl:SetFont("ZoFontWinH4")
            rowControl:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
            rowControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            rowControl:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)

            --        rowControl:SetHandler("OnMouseEnter", function(self) ShowTooltip(rowControl, data) end)
            --        rowControl:SetHandler("OnMouseExit", HideTooltip)

            rowControl:SetColor(.772549,.760784,.61960,1)


            local text = "Hello"
            rowControl:SetText(messages)
        end

        d("Hellooo")
        ZO_ScrollList_AddDataType(list, 1, "ZO_SelectableLabel", 15, listRow_Setup)
--



        --        i = i + 1
--        if message == "" or nil then return end
--
--        local label = WINDOW_MANAGER:CreateControl("a".. "Label" .. i, list, CT_LABEL)
--        label:SetText(messages)
--        label:SetHorizontalAlignment(nil)
--
--        label:SetFont("ZoFontGame")
--        label:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
--        --local textHeight = label:GetTextHeight()
--        label:SetDimensions(minWidth, 30)
--       -- label:SetDimensionConstraints(minWidth - 60, textHeight, nil, textHeight)
--        label:ClearAnchors()
--        if lastlabel == nil then
--             label:SetAnchor(TOP, list, TOP, 40, xOffset)
--        else
--            label:SetAnchor(TOP, lastlabel, CENTER, 0, xOffset + 5)
--        end
--
--        label:SetHandler("OnMouseEnter", function(self, delta, ctrl, alt, shift)
--            local offset = delta
--
--            d (offset)
--            if shift then
--                offset = offset * buffer:GetNumVisibleLines()
--            elseif ctrl then
--                offset = offset * buffer:GetNumHistoryLines()
--            end
--        end)
--
--        lastlabel = label
--        local xOffset = 0
    end


    if self.config.addonName and self.config.addonName ~= "" then
        local label = WINDOW_MANAGER:CreateControl(self.config.addonName .. "Label", lltwl, CT_LABEL)
        label:SetText(self.config.addonName)
        label:SetFont("$(ANTIQUE_FONT)|24")
        label:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
        local textHeight = label:GetTextHeight()
        label:SetDimensionConstraints(minWidth - 60, textHeight, nil, textHeight)
        label:ClearAnchors()
        label:SetAnchor(TOPLEFT, lltwl, TOPLEFT, 30, (40 - textHeight) / 2 + 5)
        label:SetAnchor(TOPRIGHT, lltwl, TOPRIGHT, -30, (40 - textHeight) / 2 + 5)
    end

    function lltwl:AddText(_Message)
        if not _Message then return end
        self:AddLabel(self, _Message)
    end

    function lltwl:ClearText()
        ZO_ScrollList_Clear(parent)
    end



    return lltwl
end



--- - Buffered Reached
--

local BufferTable = {}
function LibLuminary:BufferReached(key, buffer)
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



