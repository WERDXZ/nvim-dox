---@type table<string, nvim_dox.docstring.template>
local M = {
	["file"] = {
		{ "name", keyword = "file", value = "%s" },
		{ false, keyword = nil, value = "" }, -- justs a empty line
		{ false, keyword = "brief", value = "${brief} "}, -- everybody use $1 for text jumping idk why
		{ "author", keyword = "author", value = "%s"},
		{ false, keyword = "version", value = "${version}"},
		{ "modified_date", keyword = "date", value = "%s"},
		{ false, keyword = nil, value = ""}, -- another new line.
	},
}

return M
