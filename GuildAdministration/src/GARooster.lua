local debug = true

if(not GA.Rooster) then GA.Rooster = ZO_Object:Subclass() end
local Rooster = GA.Rooster

function Rooster:New()

    local this = ZO_Object.New(self)

	this.saved = ZO_SavedVars:New( GA.VARIABLES_DATA, GA.VARIABLES_DATA_VERSION, nil, default, GetWorldName() )
	this.data = {}

	zo_callLater( function() this:Init() end )

    return this
end

function Rooster:Init()

  local numGuilds = GetNumGuilds()
  for guildIndex=1,numGuilds do

    -- access guild data
	local guildId = GetGuildId( guildIndex )
	local guildName = GetGuildName(guildId)
	local numMembers = GetNumGuildMembers(guildId)
	
	if( debug ) then d(""..guildId..guildIndex.." "..guildName) end
	
    -- access rank names
	local rankMap = {}
	local numRanks = GetNumGuildRanks(guildId);
	for rankIndex=1,numRanks do
		local rankName = GetGuildRankCustomName(guildId, rankIndex)
		-- if( debug ) then d("   "..rankIndex.." "..rankName) end
		rankMap[rankIndex] = rankName
	end
	
	self.data[guildId] = GA.RoosterGuild:New(guildId, guildName)
	
	for memberIndex=1,numMembers do
	  local account, note, rankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, memberIndex)
	  -- _Returns:_ *string* _name_, *string* _note_, *luaindex* _rankIndex_, *[PlayerStatus|#PlayerStatus]* _playerStatus_, *integer* _secsSinceLogoff_
	  -- if( debug ) then d(account.." "..secsSinceLogoff) end
	  self.data[guildId].members[account] = {
		account = account,
		rankIndex = rankIndex,
		rankName = rankMap[rankIndex],
		secsSinceLogoff = secsSinceLogoff,
	  }

	-- sync with saved data
	-- TODO
	--   read fromsaved data what we have
	--   purge saved data

    -- start accessing libhistore

	end

  end
end

function Rooster:FindGuildByName(guildName)

	if( guildName == nil ) then return nil end

	for guildId,guildData in pairs(self.data) do
		if( guildData.name == guildName ) then
			return guildData
		end
	end

	return nil
end

