local AGS = AwesomeGuildStore
local LootLog = LootLog

local MultiChoiceFilterBase = AGS.class.MultiChoiceFilterBase

-- remark: normally from local FILTER_ID = AGS.data.FILTER_ID
local FILTER_ID_UCF = 120
local SUB_CATEGORY_ID = AGS.data.SUB_CATEGORY_ID


local UnknownCodexFilter = MultiChoiceFilterBase:Subclass()
AGS.class.UnknownCodexFilter = UnknownCodexFilter

function UnknownCodexFilter:New(...)
    return MultiChoiceFilterBase.New(self, ...)
end

function UnknownCodexFilter:Initialize()

  local filterIcons = {}
  filterIcons[1] = {
    id = "never",
    label = "Never Dug Out",
    icon = "/esoui/art/tutorial/tutorial_collections_tabicon_itemsets_%s.dds",
  }
  filterIcons[2] = {
    id = "missing",
    label = "Missing Codex Entries",
    icon = "/esoui/art/tutorial/tutorial_collections_tabicon_itemsets_%s.dds",
  }

  MultiChoiceFilterBase.Initialize(self, FILTER_ID_UCF, AGS.class.FilterBase.GROUP_LOCAL, ("Unknown Codex"), filterIcons )

  self:SetEnabledSubcategories({
    [SUB_CATEGORY_ID.CONSUMABLE_TROPHY] = true,
  })

end

function UnknownCodexFilter:FilterLocalResult(itemLink)

  	local antiquityId = LootLog.GetAntiquityIdFromItem(itemLink.itemLink)
  	-- don't show non leads, if filter is active
  	if antiquityId == 0 then
	  return false
	end

    local valueNever = self.valueById['never']
    local selectionNever = self.localSelection[valueNever]

    local valueMissing = self.valueById['missing']
    local selectionMissing = self.localSelection[valueMissing]

  	local numAquired = GetNumAntiquityLoreEntriesAcquired(antiquityId)
  	local numEntries = GetNumAntiquityLoreEntries(antiquityId)

--    local leadState, timeRemainingS, leadGroup = GetAntiquityLeadInfo(antiquityId)
--    local leadInProgress = leadState > 1
--	local leadInProgressAdd     
--    if leadInProgress then 
--    	leadInProgressAdd = 1 
--    else 
--      leadInProgressAdd = 0
--     end

--	local numAquiredWithProgress = numAquired + leadInProgressAdd
	local numAquiredWithProgress = numAquired

    if selectionNever then
      return numAquiredWithProgress == 0
    end
    
    if selectionMissing then
      if numAquiredWithProgress < numEntries then
	    return true
	  else
	    return false
	  end
    end

	d("something is wrong")
end

function ALF.initAGS()
  AGS:RegisterFilter(UnknownCodexFilter:New())
  AGS:RegisterFilterFragment(AGS.class.MultiButtonFilterFragment:New(FILTER_ID_UCF))
end