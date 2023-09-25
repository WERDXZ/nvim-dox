local builtin = {
	---@type nvim_dox.querier
	["file"] = function(_)
		-- just get the node at cursor
		return vim.treesitter.get_node()
	end,
}

return builtin
