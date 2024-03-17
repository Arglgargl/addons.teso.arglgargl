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
	
	return offline > GA.SECONDS_IN_DAY * 60
end

function SlashCommandKickOffliners:Execute(args)

	local guildData = self.rooster:FindGuildByName("Steinfreunde")

	local text = guildData:PrintMembers(IsOffliner)
	GA.OpenPopup(text)
end
