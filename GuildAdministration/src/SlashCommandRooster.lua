if(not GA.SlashCommandRooster) then GA.SlashCommandRooster = GA.SlashCommand:Subclass() end
local SlashCommandRooster = GA.SlashCommandRooster

function SlashCommandRooster:Alias()
	return "rooster"
end

function SlashCommandRooster:Description()
	return "Show rooster in popup"
end

function SlashCommandRooster:Execute(args)

	local guildData = self.rooster:FindGuildByName("Steinfreunde")

	local text = guildData:PrintMembers()
	GA.OpenPopup(text)
end
