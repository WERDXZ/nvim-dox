---@type table<string, nvim_dox.docstring.template>
local M = {
	["file"] = {
		{ "name", keyword = "file", value = "%s"},
		{ true, keyword = "brief", value = "${brief}"},
		{ "author", keyword = "author", value = "%s" },
		{ true, keyword = "version", value = "${version}" },
		{ "modified_date", keyword = "date", value = "%s" },
	},
	["function"] = {
		{ "name", keyword = "brief", value = "Function %s ${brief}." },
		{ "params", keyword = "param", value = "%s", newline="before"},
		{ "tparams", keyword = "tparam", value = "%s", newline="before"},
		{ "return", keyword = "return", value = "%s", newline="before"},
	},
	["class"] = {
		{"name", keyword="brief", value = "The %s class.", newline="before"},
		{"tparams", keyword="tparam", value = "%s", newline="before"},
	},
	["struct"] = {
		{"name", keyword="brief", value = "The %s struct.", newline="before"},
		{"tparams", keyword="tparam", value = "%s", newline="before"},
	}
}

return M
