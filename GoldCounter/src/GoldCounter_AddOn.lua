 -- Constants
 local SLASH_PRINT_TOTALS = "gctotals"
 local SLASH_PRINT_LIST = "gclist"

 -- Initialize AddOn
function GC.OnAddOnLoaded( event, addonName )
  if addonName ~= GC.NAME then
    return;
  end

  local Config_Defaults =  {
  }  
  
  -- load datastore
  GC.config = ZO_SavedVars:New( GC.VARIABLES_CONFIG, GC.VARIABLES_CONFIG_VERSION, nil, Config_Defaults )
  GC.data = GCData.loadFromSaveVariables()
  
  -- register events
  
  -- EVENT_MONEY_UPDATE (integer eventCode, integer newMoney, integer oldMoney, integer reason)
  EVENT_MANAGER:RegisterForEvent( GC.NAME, EVENT_MONEY_UPDATE, GC.OnMoneyUpdate )
  -- EVENT_ALLIANCE_POINT_UPDATE (integer eventCode, integer alliancePoints, boolean playSound, integer difference)
  
  GC.RegisterSlashCommands()
  
  GoldCounterMainWindow:SetHidden( true )

  zo_callLater( GC.OutputInitMessage, 1000 )
 
end

function GC.OutputInitMessage()
  GC.MsgGold( GC.NAME .. " v" .. GC.VERSION .. " initialized." )
end

EVENT_MANAGER:RegisterForEvent( GC.NAME, EVENT_ADD_ON_LOADED, GC.OnAddOnLoaded )

function GC.RegisterSlashCommands()
    -- -- local lsc = LibSlashCommander
    -- if not lsc and LibStub then lsc = LibStub:GetLibrary("LibSlashCommander", true) end
    -- if lsc then
        -- local langSlashCommandsEN = self.LANG["en"]["slash_commands"]
        -- local langSlashCommands = self.LANG[self.clientlang]["slash_commands"]
        -- local setStationCmdText = string.format(langSlashCommands["SC_SET_STATION"], HomeStationMarker.name, langSlashCommands["SC_SET"], langSlashCommands["SC_STATION"])
        -- local cmd = lsc:Register( "/gatest"
            -- , function(args) GA.SlashCommand(args) end
            -- , "Mein Test Text")
    -- else
        SLASH_COMMANDS["/"..SLASH_PRINT_TOTALS] = GC.PrintTotals
        SLASH_COMMANDS["/"..SLASH_PRINT_LIST] = GC.PrintList
    -- end
end

function GC.PrintTotals()
	GC.data:printTotals()
end

function GC.PrintList()
	GC.data:printTransactions()
end


-- Event Handler
-- EVENT_MONEY_UPDATE( integer eventCode, integer newMoney, integer oldMoney, integer reason )
function GC.OnMoneyUpdate( eventCode, newMoney, oldMoney, reason )
  local amount = newMoney - oldMoney
  GC.data:addTransaction(reason, amount)
end

function GC.moneyUpdateReasonToDescription( reason )

  local description = GC.I10N.reason[reason]

  if( description == nil ) then
    return "-"..GC.I10N.reason[CURRENCY_CHANGE_REASON_UNKNOWN].."-"
   end
  
  return description
  
end

-- Helper
function GC.MsgGold( text )
    d("|c" .. GC.COLOR_GOLD .. text .. "|r")
end

-- UI Code, MOVE AWAY
-- Set the visibility status of the main window to the opposite of its current status
function GC.ToggleMainWindow()
    GoldCounterMainWindow:SetHidden( not GoldCounterMainWindow:IsHidden() )
end
