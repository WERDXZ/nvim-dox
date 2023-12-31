-- this file is used to parse the result of a querier which
-- is a treesitter node or true(if doesn't need a tsnode)
-- and do some parsing on the node to get a table of
-- docstring mappings

local M = {}

---@alias nvim_dox.parser.item (fun(node:TSNode|nil, bufnr: number):table<string>|string|nil) | string | table<string>
---@alias nvim_dox.parser table<string,nvim_dox.parser.item>
---@type table<nvim_dox.type, nvim_dox.parser>
local parsers = require("nvim-dox.parser.builtin")

---register a parser for a node type
---@param node_name string
---@param parser nvim_dox.parser
M.register = function(node_name, parser)
	parsers[node_name] = parser
end

-- add readOnly constraint
setmetatable(M, {
	__index = {
		parsers = parsers,
	},
	__newindex = require("nvim-dox.util").readOnly,
})

return M
