local builtin = {
	---@type nvim_dox.parser
	["file"] = {
		["name"] = function(_)
			return vim.api.nvim_buf_get_name(0):match("^.+/(.+)$")
		end,
		["modified_date"] = function(_)
			-- local modified = vim.fn.getftime(filename)
			return vim.fn.strftime(vim.fn.getftime(vim.api.nvim_buf_get_name(0))) or ""
		end,
	},
}

return builtin
