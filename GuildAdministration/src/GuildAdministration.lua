local isdebug = true

-- Constant
local SLASH_GA = "/ga"

 -- Initialize AddOn
function GA.OnAddOnLoaded( event, addonName )
  if addonName ~= GA.NAME then
    return;
  end

  -- load datastore
  -- local Config_Defaults =  {}  
  -- local Data_Defaults =  {}
  -- GA.config = ZO_SavedVars:New( GA.VARIABLES_CONFIG, GA.VARIABLES_CONFIG_VERSION, nil, Config_Defaults )

  -- init rooster data
  GA.rooster = GA.Rooster:New()

  GA.RegisterSlashCommands()
  
  if isdebug then
	zo_callLater( GA.OutputInitMessage, 1000 )
  end
end

function GA.OutputInitMessage()
  GA.MsgGold( GA.NAME .. " v" .. GA.VERSION .. " initialized." )
end

 -- Event Handler
 EVENT_MANAGER:RegisterForEvent( GA.NAME, EVENT_ADD_ON_LOADED, GA.OnAddOnLoaded )


-- Helper
function GA.MsgGold( text )
    d("|c" .. GA.COLOR_GOLD .. text .. "|r")
end

function GA.RegisterSlashCommands()

    local mainCmd = LibSlashCommander:Register( SLASH_GA , function(args) GA.OpenPopup("Please select a sub-command") end
            , "Guild Administration")

	GA.SlashCommandRooster:New(mainCmd, GA.rooster):Register()
	GA.SlashCommandKickOffliners:New(mainCmd, GA.rooster):Register()
end


function GA.OpenPopup(text)

    local hidden = GA_ExportPopup:IsHidden()

    if not GA.editbox then
        GA.editbox = GA.CreateEditBox()

	-- local lang = GA.LANG[self.clientlang]["export"] or self.LANG["en"]["export"]
	-- HomeStationMarker_ExportUIWindowTitle:SetText(lang.WINDOW_TITLE)
    end

	GA.editbox:SetText(text:sub(1,MYSTERY_LIMIT))
	-- Scroll to top. Doesn't work immediately, but
	-- there's nothing that a SLEEP 10 can't fix!
	zo_callLater(function() GA.editbox:SetCursorPosition(0) end, 10)

    if hidden then
		GA_ExportPopup:SetHidden(false)
		SetGameCameraUIMode(true)
	end

end

function GA.Close_ExportRoosterPopup()
		GA_ExportPopup:SetHidden(true)
end

-- REMARK: from Home-StationMarkers
function GA.CreateEditBox()
    local container = GA_ExportPopup

    local backdrop = WINDOW_MANAGER:CreateControlFromVirtual( nil, container, "ZO_EditBackdrop")
    backdrop:SetAnchor(TOPLEFT,     container, TOPLEFT,      5, 50)
    backdrop:SetAnchor(BOTTOMRIGHT, container, BOTTOMRIGHT, -5, -5)

    local editbox = WINDOW_MANAGER:CreateControlFromVirtual(nil, backdrop, "ZO_DefaultEditMultiLineForBackdrop")
    editbox:SetMaxInputChars(20000)

    return editbox
end

function GA.DoAutoranking(cmd, args)

	GA.OpenPopup("Test!")
	
	-- TODO
	-- find guildid for steinfreunde
	-- find sales...
	-- apply some rules
	-- show results in popup

end

function GA.doRanking()

	-- TODO
	-- find guildid for steinfreunde
	-- find sales...
	-- apply some rules
	-- show results in popup

	local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
	for i,member in ipairs(masterList) do

		local account = member.displayName
		-- REMARK: this field is added by ShissuRoster
		local goldDeposit = member.goldDeposit or 0

		-- get rank  .rankId oder .rankIndex ?
		-- fixme find rank name?

		lines[i+1] = account.."\t"..goldDeposit
	end


end
