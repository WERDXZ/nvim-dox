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
---@alias nvim_dox.querier fun(lnum:number, col:number):nil|TSNode
---@alias nvim_dox.querier_table table<nvim_dox.type, nvim_dox.querier>

---@type nvim_dox.querier_table
M.queriers = require("nvim-dox.querier.builtin")

-- register a querier for a given type
---@param type string
---@param querier nvim_dox.querier
M.register = function(type, querier)
	M.queriers = M.queriers or {}
	M.queriers[type] = querier
end

return M
