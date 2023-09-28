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
local node_type = require("nvim-dox.type")
local completion = vim.list_extend({ "generate" }, node_type.types)
local generate = require("nvim-dox.generator").generate

M.setup = function()
	create_cmd("Dox", function(opts)
		local params = opts.fargs
		if #params == 0 then
			M.call_querier_each(0)
			return
		elseif params[1] == "generate" then
			return
		elseif params[1] == "." then
			M.call_querier_each(0)
			return
		else
			M.call_querier(params[1], 0)
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
---its seems that it is because calling queriers multiple times
---@param bufnr number
---@return boolean
M.call_querier_each = function(bufnr)
	---@type nil | TSNode | boolean
	local result = nil
	---@type nvim_dox.type|nil
	local index = nil

	for _index, _value in pairs(querier.queriers) do
		result = _value(bufnr)
		index = _index
		if result ~= nil then
			break
		end
	end

	if result == nil then
		return false
	end

	if result == true then
		result = nil
	end

	return generate(index, result, bufnr)
end

---call a specifc querier
---@param _type nvim_dox.type
---@param bufnr number
---@return boolean
M.call_querier = function(_type, bufnr)
	if querier.queriers == nil then
		return false
	end
	local node = querier.queriers[_type](bufnr)
	if node == nil or node == false then
		return false
	end

	if type(node) == "boolean" then
		node = nil
	end

	return generate(_type, node, bufnr)
end

return M
