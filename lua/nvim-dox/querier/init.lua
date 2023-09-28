-- this file is specificly used for using the correct querier for a type of docstring
-- eg. if asking for a class docstring, use the class querier that returns a class
-- treesitter node and passed on the parser.
local M = {}

-- each querier should return a treesitter node or true if found in reasonable boundries
-- return false or nil if not found
-- the querier is also used to get the correct nvim_dox.type type
-- for a given range(probably the whole file)
-- the first match is used and passed on to the parser
--
---@alias nvim_dox.querier fun(bufnr: number|nil):nil|TSNode|boolean
---@alias nvim_dox.querier_table table<nvim_dox.type, nvim_dox.querier>

---@type nvim_dox.querier_table
local queriers = require("nvim-dox.querier.builtin")

-- register a querier for a given type
---@param type string
---@param querier nvim_dox.querier
M.register = function(type, querier)
	queriers[type] = querier
end

-- add readOnly constraint
setmetatable(M, {
	__index = {
		queriers = queriers,
	},
	__newindex = require("nvim-dox.util").readOnly,
})

return M
