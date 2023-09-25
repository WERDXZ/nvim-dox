---@type nvim_dox.config.source
local M = {
	docstring = require("nvim-dox.docstring.doxygen"),
	style_config = {
		comment_prefix = "",
		comment_suffix = "",
		comment_head = "/**",
		comment_line = " * ",
		comment_tail = " */",
		keyword_prefix = "@",
	},
	style = "block",
	ft = { "c", "cpp" },
	keywords = {
		"author",
		"brief",
		"date",
		"details",
		"file",
		"ingroup",
		"license",
		"name",
		"note",
		"param",
		"return",
		"see",
		"since",
		"throw",
		"todo",
		"version",
		"warning",
	},
	location = {

	},
}

return M
