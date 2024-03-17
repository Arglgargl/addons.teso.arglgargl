if(not GA.SlashCommand) then GA.SlashCommand = ZO_Object:Subclass() end
local SlashCommand = GA.SlashCommand

function SlashCommand:New(cmdParent, rooster)

    local this = ZO_Object.New(self)
	this.cmdParent = cmdParent
	this.rooster = rooster

    return this
end

function SlashCommand:Register()
	local cmd = self.cmdParent:RegisterSubCommand()
	cmd:AddAlias(self:Alias())
	cmd:SetDescription(self.Description())
	cmd:SetCallback( function(args) self:Execute(args) end )
end

-- abstract methods
SlashCommand.Alias = SlashCommand:MUST_IMPLEMENT()
SlashCommand.Description = SlashCommand:MUST_IMPLEMENT()
SlashCommand.Execute = SlashCommand:MUST_IMPLEMENT()
