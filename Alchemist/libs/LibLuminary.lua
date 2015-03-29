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

    return LibLuminary:CreateMsgWindow(self)
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



    function lltwl:AddText(_Message, _Red, _Green, _Blue)
        local Red = _Red or 1
        local Green = _Green or 1
        local Blue = _Blue or 1

        if not _Message then return end
        -- Add message first
        self:GetNamedChild("Buffer"):AddMessage(_Message, Red, Green, Blue)
        -- Set new slider value & check visibility
        AdjustSlider(self)
    end

    function lltwl:ClearText()
        self:GetNamedChild("Buffer"):Clear()
    end

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


    local txtBuffer = WINDOW_MANAGER:CreateControl(self.config.addonName .. "Buffer", lltwl, CT_TEXTBUFFER)
    txtBuffer:SetFont("ZoFontChat")
    --txtBuffer:SetScrollPosition(350)
    --txtBuffer:MoveScrollPosition(350)

    txtBuffer:SetMaxHistoryLines(600)
    txtBuffer:SetMouseEnabled(true)
    txtBuffer:SetLinkEnabled(true)
    txtBuffer:SetAnchor(TOPLEFT, lltwl, TOPLEFT, 20, 65)
    txtBuffer:SetAnchor(BOTTOMRIGHT, lltwl, BOTTOMRIGHT, -35, -20)
    txtBuffer:SetHandler("OnLinkMouseUp", function(self, linkText, link, button)
    --TODO add popup clickable to view item
        ZO_PopupTooltip_SetLink(link)
        ZO_LinkHandler_OnLinkMouseUp(link, button, self)
    end)
    txtBuffer:SetDimensionConstraints(minWidth - 50, minHeight - 50)

    txtBuffer:SetHandler("OnMouseWheel", function(self, delta, ctrl, alt, shift)
        local offset = delta
        local slider = txtBuffer:GetParent():GetNamedChild("Slider")
        if shift then
            offset = offset * txtBuffer:GetNumVisibleLines()
        elseif ctrl then
            offset = offset * txtBuffer:GetNumHistoryLines()
        end
        txtBuffer:SetScrollPosition(txtBuffer:GetScrollPosition() + offset)
        slider:SetValue(slider:GetValue() - offset)
    end)

    local slider = WINDOW_MANAGER:CreateControl(self.config.addonName .. "Slider", lltwl, CT_SLIDER)
    slider:SetDimensions(16, 31)
    slider:SetAnchor(TOPRIGHT, lltwl, TOPRIGHT, -24, 59)
    slider:SetAnchor(BOTTOMRIGHT, lltwl, BOTTOMRIGHT, -14, -79)
    slider:SetHidden(true)
    slider:SetThumbTexture("EsoUI/Art/ChatWindow/chat_thumb.dds", "EsoUI/Art/ChatWindow/chat_thumb_disabled.dds", nil, 9, 23, nil, nil, 0.6975, nil)
    slider:SetBackgroundMiddleTexture("EsoUI/Art/ChatWindow/chat_scrollbar_track.dds")
    slider:SetMinMax(1, 1)
    slider:SetMouseEnabled(true)
    slider:SetValueStep(1)
    slider:SetValue(1)


    slider:SetHandler("OnValueChanged", function(self, value, eventReason)
        local numHistoryLines = self:GetParent():GetNamedChild("Buffer"):GetNumHistoryLines()
        local sliderValue = slider:GetValue()

        if eventReason == EVENT_REASON_HARDWARE then
            txtBuffer:SetScrollPosition(numHistoryLines - sliderValue)
        end
    end)


    local scrollUp = WINDOW_MANAGER:CreateControlFromVirtual(self.config.addonName .. "SliderScrollUp", slider, "ZO_ScrollUpButton")
    scrollUp:SetAnchor(BOTTOM, slider, TOP, -1, 0)
    scrollUp:SetNormalTexture("EsoUI/Art/ChatWindow/chat_scrollbar_upArrow_up.dds")
    scrollUp:SetPressedTexture("EsoUI/Art/ChatWindow/chat_scrollbar_upArrow_down.dds")
    scrollUp:SetMouseOverTexture("EsoUI/Art/ChatWindow/chat_scrollbar_upArrow_over.dds")
    scrollUp:SetDisabledTexture("EsoUI/Art/ChatWindow/chat_scrollbar_upArrow_disabled.dds")
    scrollUp:SetHandler("OnMouseDown", function(...)
        txtBuffer:SetScrollPosition(txtBuffer:GetScrollPosition() - 20)
        slider:SetValue(slider:GetValue() - 1)
    end)


    local scrollDown = WINDOW_MANAGER:CreateControlFromVirtual(self.config.addonName .. "SliderScrollDown", slider, "ZO_ScrollDownButton")
    scrollDown:SetAnchor(TOP, slider, BOTTOM, -1, 0)
    scrollDown:SetNormalTexture("EsoUI/Art/ChatWindow/chat_scrollbar_downArrow_up.dds")
    scrollDown:SetPressedTexture("EsoUI/Art/ChatWindow/chat_scrollbar_downArrow_down.dds")
    scrollDown:SetMouseOverTexture("EsoUI/Art/ChatWindow/chat_scrollbar_downArrow_over.dds")
    scrollDown:SetDisabledTexture("EsoUI/Art/ChatWindow/chat_scrollbar_downArrow_disabled.dds")
    scrollDown:SetHandler("OnMouseDown", function(...)
        txtBuffer:SetScrollPosition(txtBuffer:GetScrollPosition() - 1)
        slider:SetValue(slider:GetValue() + 1)
    end)


    local scrollEnd = WINDOW_MANAGER:CreateControlFromVirtual(self.config.addonName .. "SliderScrollEnd", slider, "ZO_ScrollEndButton")
    scrollEnd:SetDimensions(16, 16)
    scrollEnd:SetAnchor(TOP, scrollDown, BOTTOM, 0, 0)
    scrollEnd:SetHandler("OnMouseDown", function(...)
        txtBuffer:SetScrollPosition(0)
        slider:SetValue(txtBuffer:GetNumHistoryLines())
    end)

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
    return lltwl
end



---- Buffered Reached
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



