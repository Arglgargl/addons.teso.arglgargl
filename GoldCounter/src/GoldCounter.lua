 -- Initialize AddOn
function GC.OnAddOnLoaded( event, addonName )
  if addonName ~= GC.NAME then
    return;
  end

  local Config_Defaults =  {
  }  
  
  local Data_Defaults =  {
    ['TransactionsCount'] = 0,  
    ['Transactions'] = {}  
  }  

  -- load datastore
  GC.config = ZO_SavedVars:New( GC.VARIABLES_CONFIG, GC.VARIABLES_CONFIG_VERSION, nil, Config_Defaults )
  GC.data = ZO_SavedVars:New( GC.VARIABLES_DATA, GC.VARIABLES_DATA_VERSION, nil, Data_Defaults )
  
  -- register events
  EVENT_MANAGER:RegisterForEvent( GC.NAME, EVENT_MONEY_UPDATE, GC.OnMoneyUpdate )
  -- EVENT_ALLIANCE_POINT_UPDATE (integer eventCode, integer alliancePoints, boolean playSound, integer difference)
  -- EVENT_MONEY_UPDATE (integer eventCode, integer newMoney, integer oldMoney, integer reason)
  
  GoldCounterMainWindow:SetHidden( true )
  
  zo_callLater( GC.OutputInitMessage, 4000 )
end

function GC.OutputInitMessage()
  GC.MsgGold( GC.NAME .. " v" .. GC.VERSION .. " initialized." )
end

EVENT_MANAGER:RegisterForEvent( GC.NAME, EVENT_ADD_ON_LOADED, GC.OnAddOnLoaded )

-- Database
function GC.logGold( amount, reason, description )

  local description = GC.moneyUpdateReasonToDescription( reason )
  local now = GetTimeStamp()

  GC.MsgGold( 'Currency-transfer: Amount= '..amount.." Reason= "..reason.." Description= "..description )

  GC.data.TransactionsCount = GC.data.TransactionsCount + 1 

  GC.data.Transactions[GC.data.TransactionsCount] = {
    ['time']   = now,
    ['amount'] = amount,
    ['reason'] = reason
  }
  
end

-- Event Handler
-- EVENT_MONEY_UPDATE( integer eventCode, integer newMoney, integer oldMoney, integer reason )
function GC.OnMoneyUpdate( eventCode, newMoney, oldMoney, reason )

  local amount = newMoney - oldMoney
  GC.logGold( amount, reason )

end

function GC.moneyUpdateReasonToDescription( reason )

  local description = GC.I10N.reason[reason]

  if( description == nil ) then
    return SK_REASON_DESCRIPTION_UNKNOWN
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