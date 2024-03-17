if(not GA.SlashCommandKickOffliners) then GA.SlashCommandKickOffliners = GA.SlashCommand:Subclass() end
local SlashCommandKickOffliners = GA.SlashCommandKickOffliners

function SlashCommandKickOffliners:Alias()
	return "kickoffliners"
end

function SlashCommandKickOffliners:Description()
	return "Kick Offliners"
end

local function IsOffliner(member)

	local offline = member.secsSinceLogoff
	local rankIndex = member.rankIndex

	-- only apply rules for ranks 7 & 8
	-- TODO: put these constants somewhere else (rank 7 and 60days)
	if( rankIndex < 7 ) then return false end
	
	return offline > GA.SECONDS_IN_DAY * 60
end

function SlashCommandKickOffliners:Execute(args)

	local guildData = self.rooster:FindGuildByName("Steinfreunde")
	local offliners, offlinercount = guildData:FilterMembers(IsOffliner);

	local message = "Are your sure to kick "..offlinercount.." member(s)?"
	for account,member in pairs(offliners.members) do
		message = message.."\n"..account.." ("..member.rankName..")"
	end

	local callbackYes = function()
		for account,member in pairs(offliners.members) do
			d("Kickking "..account)
			GuildRemove(offliners.id, account)
		end
	end

	LibDialog:RegisterDialog(GA.NAME, "GAKickoffliner", "Kick-Offliners", message, callbackYes, nil, nil, true)
	LibDialog:ShowDialog(GA.NAME, "GAKickoffliner", {})
end
