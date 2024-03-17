
local OFFFLINER_MAX_DAYS = 60

local STR_KICKMAIL_MESSAGE = [[
Hey, nur eine kurze Testmail ob der Mailversand mit meinen Addon klappt.

Hi %s,

sorry, you have been kicked from Steinfreunde due to %d days of activity.

Don't worry :) I you want to come back simply re-apply or PM me.

Cheers
Steinfreunde
]]


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
	
	return offline > GA.SECONDS_IN_DAY * OFFFLINER_MAX_DAYS
end

function SlashCommandKickOffliners:Execute(args)

	local guildData = self.rooster:FindGuildByName("Steinfreunde")
	local offliners, offlinercount = guildData:FilterMembers(IsOffliner);

	local message = "Are your sure to kick "..offlinercount.." member(s)?"
	for account,member in pairs(offliners.members) do
		message = message.."\n"..account.." ("..member.rankName..")"
	end

	local callbackYes = function()
	
		local mailBody = string.format(STR_KICKMAIL_MESSAGE, "@Testaccount", OFFFLINER_MAX_DAYS)

		RequestOpenMailbox()

		for account,member in pairs(offliners.members) do
			d("Kicking "..account)
			GuildRemove(offliners.id, account)

			SendMail(account, "Steinfreunde says Good Bye", mailBody)
		end
		
		CloseMailbox()
	end

	LibDialog:RegisterDialog(GA.NAME, "GAKickoffliner", "Kick-Offliners", message, callbackYes, nil, nil, true)
	LibDialog:ShowDialog(GA.NAME, "GAKickoffliner", {})
end
