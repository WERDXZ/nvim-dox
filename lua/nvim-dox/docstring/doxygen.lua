---@type table<string, nvim_dox.docstring.template>
local M = {
	["file"] = {
		{ "name", keyword = "file", value = "%s"},
		{ true, keyword = "brief", value = "${brief}"},
		{ "author", keyword = "author", value = "%s" },
		{ true, keyword = "version", value = "${version}" },
		{ "modified_date", keyword = "date", value = "%s", newline=true},
	},
	["function"] = {
		{ "name", keyword = "brief", value = "Function %s ${brief}." },
		{ "params", keyword = "param", value = "%s", newline=true},
		{ "tparams", keyword = "tparam", value = "%s", newline=true},
		{ "return", keyword = "return", value = "%s", newline=true},
	},
}

return M
