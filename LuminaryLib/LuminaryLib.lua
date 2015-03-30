--local LL = LibStub('LibLuminary-2.0', 1)
--if (not LL) then return end
--
--
local LuminaryLib = ZO_Object:New()
local ADDON_NAME = "LuminaryLib"
local ROW_HEIGHT = 30


function LuminaryLib:New()
    local obj = ZO_Object.New(self)
    obj.name = ADDON_NAME
    obj.version = 1.6
    obj.tbl = {}
    obj.sv = {}
    obj.colors = {
        red = "|cFF0000",
        darkOrange = "|cFFA500",
        yellow = "|cFFFF00",
    }
    return obj
end

function LuminaryLib:Initialize()

    self.scrollList = self:CreateScrollList()

    local entryList = ZO_ScrollList_GetDataList(self.scrollList)
    local gender = 1
    if not self.tbl[gender] then
        self.tbl[gender] = {}
    end
    local something = 0
    local stuff = {
        hello = "hello"
    }
    for i = 1, 15 do
        something = something + 1
        table.insert(self.tbl[gender], stuff)
    end

    for i = 1, #self.tbl[gender] do

        local entry = ZO_ScrollList_CreateDataEntry(1, self.tbl[gender][i])
        table.insert(entryList, entry)
    end

    if not self.scrollList == nil then
        ZO_ScrollList_Commit(self.scrollList)
    end
end

function LuminaryLib:UpdateScrollList()

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

function LuminaryLib:ClearList()
    ZO_ScrollList_Clear(self.scrollList)
end



local function DoSomething()
    d("Do Something")
end

function LuminaryLib:CreateScrollList()

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

local function OnAddOnLoaded(eventCode, addOnName)
    if (ADDON_NAME ~= addOnName) then return end
    LUMINARY_LIB = LuminaryLib:New()
    LUMINARY_LIB:Initialize()


    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, DoSomething)
    -- EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_CRAFTING_STATION_INTERACT,  LUMINARY_LIB:ClearList())
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

SLASH_COMMANDS["/foo"] = function(extra)
    LUMINARY_LIB:ClearList()
end

SLASH_COMMANDS["/up"] = function(extra)
    LUMINARY_LIB:UpdateScrollList()
end


