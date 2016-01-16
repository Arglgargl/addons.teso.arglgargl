-- Namespace and Constants
GC = {}
GC.NAME = "GoldCounter"
GC.VERSION = "0.0.2"
GC.COLOR_GOLD = "d4af37"

 -- Initialize AddOn
function GC.OnAddOnLoaded( event, addonName )
  if addonName ~= GC.NAME then
    return;
  end
  
  -- TODO: load datastore
  
  zo_callLater( GC.OutputInitMessage, 4000 )
end

function GC.OutputInitMessage()
  GC.MsgGold( GC.NAME .. " v" .. GC.VERSION .. " initialized." )
end

EVENT_MANAGER:RegisterForEvent( GC.NAME, EVENT_ADD_ON_LOADED, GC.OnAddOnLoaded )

-- Helper
function GC.MsgGold( text )
    d("|c" .. GC.COLOR_GOLD .. text .. "|r")
end