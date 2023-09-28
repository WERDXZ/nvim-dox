local M = {}

---@enum nvim_dox.type
local types = {
	"file",
	"class",
	"struct",
	"function",
	"variable",
}

---@enum nvim_dox.location
local locations = {
	"above", -- above the current TS-node
	"below", -- below the current TS-node
	"top", -- top of the file
	"bottom", -- bottom of the file 
	"after" -- after the current TS-node(the same line, mostly used for variables)
}

M.extend_type = function(type)
	table.insert(types, type)
end

M.extend_location = function(location)
	table.insert(locations, location)
end

-- add readOnly constraint
setmetatable(M, {
	__index = {
		types = types,
		locations = locations,
	},
	__newindex = require("nvim-dox.util").readOnly,
})


return M
