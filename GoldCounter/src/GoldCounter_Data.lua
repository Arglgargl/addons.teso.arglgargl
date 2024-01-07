local MAX_TRANSACTION_LENGTH = 5

local default = {
    transactions = {head = 0, tail = 0},
	total = {},
}

-- transactions queue

local transaction_length = function(transactions)
  return transactions.tail - transactions.head
end

local transaction_is_empty = function(transactions)
  return transactions:length() == 0
end

local transaction_pop = function(transactions)
  -- if transactions:is_empty() then return nil end
  local r = transactions[transactions.head+1]
  transactions.head = transactions.head + 1
  local r = transactions[transactions.head]
  transactions[transactions.head] = nil
  return r
end

local transaction_push = function(transactions, x)
  assert(x ~= nil)
  transactions.tail = transactions.tail + 1
  transactions[transactions.tail] = x
  
  if( transaction_length(transactions) > MAX_TRANSACTION_LENGTH ) then
	transaction_pop(transactions)
  end
end

-- public functions

local function addTransaction(self, reason, amount)

	-- log
    local description = GC.moneyUpdateReasonToDescription( reason )
    d(string.format("%s: %s", description, amount))
	
	-- add single transaction
    local now = GetTimeStamp()
	local transaction =  {
		timestamp = now,
		reason = reason, 
		amount = amount,
	}

	transaction_push(self.data.transactions, transaction)

	-- add to total

    local reasonData = self.data['total'][reason] or {}
	self.data['total'][reason] = reasonData

    local amountType
	if amount > 0 then amountType = "earned" else amountType = "lost" end

    local total = reasonData[amountType] or 0
    reasonData[amountType] = total + amount

end

local function printTotals(self)

    local totals = self.data['total']
	for reason,values in pairs(totals) do
	
        local description = GC.moneyUpdateReasonToDescription( reason )

		local earned = values['earned']
		if earned then
			d( string.format( "%s %d", description, earned ) )
		end

		local lost = values['lost']
		if lost then
			d( string.format( "%s %d", description, lost ) )
		end

	end

end

local function printTransactions(self)

    local transactions = self.data['transactions']
	
	for i=transactions.head+1,transactions.tail do
        local transaction = transactions[i]

        local description = GC.moneyUpdateReasonToDescription( transaction["reason"] )
		local timestamp = transaction["timestamp"]
		local amount = transaction["amount"]

		d( string.format( "%s %d", description, amount ) )
	end

end

-- 'class' construction

local methods = {
  addTransaction = addTransaction,
  printTotals = printTotals,
  printTransactions = printTransactions,
}

local function loadFromSaveVariables()
	local this = {}
	
	this.data = ZO_SavedVars:New( GC.VARIABLES_DATA, GC.VARIABLES_DATA_VERSION, nil, default, GetWorldName() )
	
	return setmetatable(this, {__index = methods})
end

GCData = GCData or { 
					 loadFromSaveVariables = loadFromSaveVariables,
                     apply = apply,
				   }
