local debug = true

if(not GA.RoosterGuild) then GA.RoosterGuild = ZO_Object:Subclass() end
local RoosterGuild = GA.RoosterGuild

function RoosterGuild:New(guildId, guildName)

    local this = ZO_Object.New(self)

	this.id = guildId
	this.name = guildName
	this.members = {}

    return this
end

-- Returns a copy of this object, but members are filtered by the given predicate
-- return RoosterGuild copy, integer count
function RoosterGuild:FilterMembers(predicate)
	local copy = RoosterGuild:New(self.id, self.name)
	
		local count = 0
		for account,member in pairs(self.members) do

			if( predicate( member) ) then
				copy.members[account] = member
				count = count + 1
			end
		end

	return copy, count
end

function RoosterGuild:PrintMembers(predicate)

	if predicate == nil then
		predicate = function(member) return true end
	end

	local guildName = self.name
	local depositType = "kaputt" --shissuRoster["gold"]

	local lines = {}

	local header = string.format("Account (%s)\tRank\tOffline Since\tDeposit (%s)",guildName, depositType)
	table.insert(lines, header)

	--local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
	for account,member in pairs(self.members) do

		if( predicate(member) ) then

			-- REMARK: this field is added by ShissuRoster
			--local goldDeposit = member.goldDeposit or 0
			local goldDeposit = 0
			local offlineSince = member.secsSinceLogoff / GA.SECONDS_IN_DAY
			local offlineSinceText = string.format("%.4f", offlineSince )
			local rankName = member.rankName

			table.insert(lines, account.."\t"..rankName.."\t"..offlineSinceText.."\t"..goldDeposit )
		end
	end

	return table.concat(lines, "\n")
end
