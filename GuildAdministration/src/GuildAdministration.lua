
-- Constant
local SLASH_EXPORT_ROOSTER = "gaexport"

 -- Initialize AddOn
function GA.OnAddOnLoaded( event, addonName )
  if addonName ~= GA.NAME then
    return;
  end
  
  -- load datastore
  -- local Config_Defaults =  {}  
  -- local Data_Defaults =  {}
  -- GA.config = ZO_SavedVars:New( GA.VARIABLES_CONFIG, GA.VARIABLES_CONFIG_VERSION, nil, Config_Defaults )
  -- GA.data = ZO_SavedVars:New( GA.VARIABLES_DATA, GA.VARIABLES_DATA_VERSION, nil, Data_Defaults )

  GA.RegisterSlashCommands()
  
  zo_callLater( GA.OutputInitMessage, 1000 )
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
    -- local self = GA
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
        SLASH_COMMANDS["/"..SLASH_EXPORT_ROOSTER] = GA.Show_ExportRoosterPopup
    -- end
end

function GA.Show_ExportRoosterPopup(cmd, args)

    local hidden = GA_ExportPopup:IsHidden()

    if not GA.editbox then
        GA.editbox = GA.CreateEditBox()

	-- local lang = GA.LANG[self.clientlang]["export"] or self.LANG["en"]["export"]
	-- HomeStationMarker_ExportUIWindowTitle:SetText(lang.WINDOW_TITLE)
    end

	local text = GA.ExportGuildlist()
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

    local backdrop = WINDOW_MANAGER:CreateControlFromVirtual( nil
                                                            , container
                                                            , "ZO_EditBackdrop"
                                                            )
    backdrop:SetAnchor(TOPLEFT,     container, TOPLEFT,      5, 50)
    backdrop:SetAnchor(BOTTOMRIGHT, container, BOTTOMRIGHT, -5, -5)

    local editbox = WINDOW_MANAGER:CreateControlFromVirtual(
          nil
        , backdrop
        , "ZO_DefaultEditMultiLineForBackdrop"
        )

    editbox:SetMaxInputChars(20000)

    return editbox
end

function GA.ExportGuildlist()

	-- FIXME: make table and concat
	local output = ""
	local lines = {}

	GUILD_ROSTER_MANAGER:RefreshData()

	local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
	for i = 1, #masterList do 
		local member = masterList[i]
		
		local account = member.displayName
		-- REMARK: this filed is probably added by ShissuHistoryScanner / ShissuRooster
		local goldDeposit = member.goldDeposit or 0

		local line = account.."\t"..goldDeposit
		output = output..line.."\n"
		lines[i] = line
	end
	
	return table.concat(lines, "\n")
	
--	return output
end
