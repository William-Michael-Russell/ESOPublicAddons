local MAJOR, MINOR = "LibLuminary-2.0", 1
local LibLuminary, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibLuminary then return end --the same or newer version of self lib is already loaded into memory


LibLuminary.config = {}

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
    return LibLuminary:CreateScrollList(self)
end


function LuminaryLib:CreateScrollList()

    local ltlw = WINDOW_MANAGER:CreateTopLevelWindow(self.appName)
    ltlw:SetDimensions(275, 200)
    ltlw:SetHidden(false)
    ltlw:SetMouseEnabled(true)
    ltlw:SetMovable(true)
    -- Exception for positioning if esoStats is loaded.

    ltlw:SetAnchor(CENTER, GuiRoot, CENTER, 15, 0)

    ltlw:SetHandler("OnShow", function()
        self.playerRank = GetUnitAvARank("player")
        local scrollList = PVP_RANKS.scrollList
        local scrollBar = scrollList.scrollbar
        local minValue, maxValue = scrollBar:GetMinMax()
        local centerValue = self.playerRank * ROW_HEIGHT - (scrollList:GetHeight() / 2)
        scrollBar:SetValue(centerValue)
    end)

    local bg = WINDOW_MANAGER:CreateControl( "Bg7z", ltlw, CT_BACKDROP)
    bg:SetAnchorFill(ltlw)

    bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
    bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    bg:SetInsets(32, 32, -32, -32)
    --    bg:SetDimensionConstraints(500, 500)

    local list = WINDOW_MANAGER:CreateControlFromVirtual("awesomezzList", ltlw, "ZO_ScrollList")
    self.scrollList = list
    list:SetAnchor(TOPLEFT, ltlw, TOPLEFT, 10, 30)
    list:SetAnchor(BOTTOMRIGHT, ltlw, BOTTOMRIGHT, -10, -10)
    list:SetAlpha(1)

    self.c_scrollList = list

    local function listRow_Setup(rowControl, data, list)
        rowControl:SetHeight(ROW_HEIGHT)
        rowControl:SetFont("ZoFontWinH4")
        rowControl:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        rowControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        rowControl:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)

        -- rowControl:SetHandler("OnMouseEnter", function(rowControl) ShowTooltip(rowControl, data) end)
        -- rowControl:SetHandler("OnMouseExit", HideTooltip)

        local rankInfo = data.dataEntry.data
        if rankInfo.rankNum == self.playerRank then
            rowControl:SetColor(1, 0, 0, 1)
        else
            --rowControl:SetColor(1,.784,.588,1)
            rowControl:SetColor(.772549, .760784, .61960, 1)
        end


        rowControl:SetText(data.hello)
    end

    ZO_ScrollList_AddDataType(list, 1, "ZO_SelectableLabel", ROW_HEIGHT, listRow_Setup)

    return list
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



