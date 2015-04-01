local MAJOR, MINOR = "LibLuminary-2.0", 1
local LibLuminary, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibLuminary then return end --the same or newer version of self lib is already loaded into memory

local ROW_HEIGHT = 50
--function LibLuminary:new(config)
--    local obj = ZO_Object.new(self)
--
--    obj.name = config.appName
--    obj.version = 1.6
--    obj.tbl = {}
--    obj.sv = {}
--    obj.colors = {
--        red = "|cFF0000",
--        darkOrange = "|cFFA500",
--        yellow = "|cFFFF00",
--    }
--- -    obj.config = config.config or {}
-- width = config.width or 300
-- obj.config = {
-- height =  50
-- }
--
-- anchorTargetControl = config.anchorTargetControl
-- animationTime = config.animationTime or DEFAULT_SCENE_TRANSITION_TIME;
-- offsetX = config.x or LEFT
-- offsetY = config.y or RIGHT
-- top = config.top or TOP
-- obj.wm = GetWindowManager()
--
--    return obj
--end

function LibLuminary:fucker()
    d(self.win.anchorTargetControl)
end

function LibLuminary:TestCases()
    assert(self.testCase == "Simple Test Case", "SimpleTest Case failed, check setup.")
end

function LibLuminary:New(cfg)
    local obj = ZO_Object.New(self)
    obj.name = ADDON_NAME
    obj.version = 1.6
    obj.testCase = "Simple Test Case"
    obj.tbl = {}
    obj.sv = {}
    obj.colors = {
        red = "|cFF0000",
        darkOrange = "|cFFA500",
        yellow = "|cFFFF00",
    }
    obj.win = {
        anchorTargetControl = cfg.anchorTargetControl or GuiRoot,
        height = cfg.height or 400,
        width = cfg.width or 400,
        animationTime = cfg.animationTime or DEFAULT_SCENE_TRANSITION_TIME,
        offsetX = cfg.x or LEFT,
        offsetY = cfg.y or RIGHT,
        top = cfg.top or TOP,
        wm = GetWindowManager() or nil,
    }
    obj.config = {
        addonName = cfg.addonName or "PleaseProvideAddonNameTo_LuminaryLib"
    }

    return obj
end

function LibLuminary:Initialize(t)

    self.scrollList = self:CreateScrollList()

    local entryList = ZO_ScrollList_GetDataList(self.scrollList)
    local gender = 1
    if not self.tbl[gender] then
        self.tbl[gender] = {}
    end

--        for i = 1, 15 do
--            something = something + 1
--            table.insert(self.tbl[gender], stuff)
--        end
--
--        for i = 1, #self.tbl[gender] do
--
--            local entry = ZO_ScrollList_CreateDataEntry(1, self.tbl[gender][i])
--            table.insert(entryList, entry)
--        end
--
--        if not self.scrollList == nil then
--            ZO_ScrollList_Commit(self.scrollList)
--        end
    self:TestCases()
end

function LibLuminary:UpdateScrollList()

    -- if self.scrollList ~= nil then
    ZO_ScrollList_Clear(self.scrollList)
    -- end

    local entryList = ZO_ScrollList_GetDataList(self.scrollList)
    local gender = 1
    if not self.tbl[gender] then
        self.tbl[gender] = {}
    end

    self.tbl[gender] = {}
    local something = 0
    local stuff = {
        hello = "hello111"
    }
    for i = 1, 15 do
        something = something + 1
        table.insert(self.tbl[gender], stuff)
    end

    for i = 1, #self.tbl[gender] do

        local entry = ZO_ScrollList_CreateDataEntry(1, self.tbl[gender][i])
        table.insert(entryList, entry)
    end

    ZO_ScrollList_Commit(self.scrollList)
end

function LibLuminary:ClearList()
    ZO_ScrollList_Clear(self.scrollList)
end



local function DoSomething()
    d("Do Something")
end

function LibLuminary:CreateScrollList()


    local tlw = WINDOW_MANAGER:CreateTopLevelWindow("awesomezz")
    tlw:SetDimensions(275, 200)
    tlw:SetHidden(false)
    tlw:SetMouseEnabled(true)
    tlw:SetMovable(true)
    -- Exception for positioning if esoStats is loaded.

    tlw:SetAnchor(CENTER, GuiRoot, CENTER, 15, 0)

    tlw:SetHandler("OnShow", function()
        --        self.playerRank = GetUnitAvARank("player")
        --        local scrollList = PVP_RANKS.scrollList
        --        local scrollBar = scrollList.scrollbar
        --        local minValue, maxValue = scrollBar:GetMinMax()
        --        local centerValue = self.playerRank * ROW_HEIGHT - (scrollList:GetHeight() / 2)
        --        scrollBar:SetValue(centerValue)
    end)

    local bg = WINDOW_MANAGER:CreateControl("Bg7z", tlw, CT_BACKDROP)
    bg:SetAnchorFill(tlw)

    bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
    bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    bg:SetInsets(32, 32, -32, -32)
    --    bg:SetDimensionConstraints(500, 500)

    local list = WINDOW_MANAGER:CreateControlFromVirtual("awesomezzList", tlw, "ZO_ScrollList")
    self.scrollList = list
    list:SetAnchor(TOPLEFT, tlw, TOPLEFT, 10, 30)
    list:SetAnchor(BOTTOMRIGHT, tlw, BOTTOMRIGHT, -10, -10)
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

    -- ZO_ScrollList_Clear(self.scrollList)


    return list
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



