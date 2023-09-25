local M = {}

---@enum nvim_dox.type
M.types = {
	"file",
	"class",
	"struct",
	"function",
	"variable",
}

---@enum nvim_dox.location
M.locations = {
	"above", -- above the current TS-node
	"below", -- below the current TS-node
	"top", -- top of the file
	"bottom", -- bottom of the file 
	"after" -- after the current TS-node(the same line, mostly used for variables)
}

M.extend_type = function(type)
	table.insert(M.types, type)
end

M.extend_location = function(location)
	table.insert(M.locations, location)
end

return M
