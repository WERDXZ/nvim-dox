local builtin = {
	---@type nvim_dox.parser
	["file"] = {
		["name"] = function(_,bufnr)
			return vim.api.nvim_buf_get_name(bufnr):match("^.+/(.+)$")
		end,
		["modified_date"] = function(_,bufnr)
			-- local modified = vim.fn.getftime(filename)
			return vim.fn.strftime(vim.fn.getftime(vim.api.nvim_buf_get_name(bufnr))) or ""
		end,
	},
	---@type nvim_dox.parser
	["function"] = {
		["return"] = function (node, bufnr)
			local return_type = node and node:named_child(0) or nil
			if return_type then
				return vim.treesitter.get_node_text(return_type, bufnr)
			end
		end,
		["params"] = function (node, bufnr)
			
		end
	}
}

return builtin
