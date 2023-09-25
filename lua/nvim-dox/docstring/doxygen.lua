---@type table<string, nvim_dox.docstring.template>
local M = {
	["file"] = {
		{ "name", keyword = "file", value = "%s" },
		{ true, keyword = nil, value = "" }, -- justs a empty line
		{ true, keyword = "brief", value = "${brief} "}, -- everybody use $1 for text jumping idk why
		{ "author", keyword = "author", value = "%s"},
		{ true, keyword = "version", value = "${version}"},
		{ "modified_date", keyword = "date", value = "%s"},
		{ true, keyword = nil, value = ""}, -- another new line.
	},
}

return M
