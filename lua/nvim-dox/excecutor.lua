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
			M.call_querier_each()
			return
		elseif params[1] == "generate" then
			return
		else
			M.call_querier(params[1])
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
---@return boolean
M.call_querier_each = function()
	---@type nil | TSNode
	local result = nil
	---@type nvim_dox.type|nil
	local index = nil

	for _index, _value in pairs(querier.queriers) do
		result = _value(unpack(vim.api.nvim_win_get_cursor(0)))
		index = _index
		if result ~= nil then
			break
		end
	end

	-- there are two ways to implement, one is to call the top generator to do all the work
	-- or call every function here

	return generate(index, result) == false
end

---call a specifc querier
---@param _type nvim_dox.type
---@return boolean
M.call_querier = function(_type)
	local node = querier.queriers[_type](unpack(vim.api.nvim_win_get_cursor(0)))
	if node == nil or node == false then
		return false
	end

	return generate(_type, node) == false
end

return M
