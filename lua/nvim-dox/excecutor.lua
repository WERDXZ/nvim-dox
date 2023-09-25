-- this file is used to register all the user commands like:
-- `Dox`
-- `Dox [type]`
-- `Dox generate`
--
-- for command `Dox`, it loop through and run all the registered queriers that have a `type`
-- avaliable for the current filetype and pass on the first result thats not false
-- or nil to the parser

local M = {}

local querier = require("nvim-dox.querier")
local create_cmd = vim.api.nvim_create_user_command
local type = require("nvim-dox.type")
local completion = vim.list_extend({ "generate" }, type.types)
local generate = require("nvim-dox.docstring").generate

M.setup = function()
	create_cmd("Dox", function(opts)
		local params = opts.fargs
		if #params == 0 then
			M.call_querier_each(0)
			return
		elseif params[1] == "generate" then
			return
		else
			M.call_querier(params[1],0)
			return
		end
	end, {
		bang = true,
		nargs = "?",
		complete = function(_, _, _)
			return completion
		end,
	})
end

---call each queriers
---@param bufrn number
---@return boolean
M.call_querier_each = function(bufrn)
	---@type nil | TSNode
	local result = nil
	---@type nvim_dox.type|nil
	local index = nil

	for _index, _value in pairs(querier.queriers) do
		result = _value(bufrn)
		index = _index
		if result ~= nil then
			break
		end
	end

	-- there are two ways to implement, one is to call the top generator to do all the work
	-- or call every function here

	return generate(index, result, bufrn) == false
end

---call a specifc querier
---@param _type nvim_dox.type
---@param bufrn number
---@return boolean
M.call_querier = function(_type, bufrn)
	if querier.queriers == nil then
		return false
	end
	local node = querier.queriers[_type](bufrn)
	if node == nil or node == false then
		return false
	end

	return generate(_type, node, bufrn) == false
end

return M
