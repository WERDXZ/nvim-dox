local get_named_parent = require("nvim-dox.util").get_named_parent

---@type nvim_dox.querier_table
local builtin = {
	---@type nvim_dox.querier
	["file"] = function(_)
		-- if the cursor is at first line
		if vim.fn.line(".") == 1 then
			-- just get the node at cursor
			return true
		end
		return nil
	end,
	---@type nvim_dox.querier
	["function"] = function (bufnr)
		local func = {"function_definition","template_declaration"}
		local node = get_named_parent(vim.treesitter.get_node({bufnr=bufnr}), func)

		if node and node:type() == "template_declaration" then
			node = node:named_child(1)
		end

		-- debug
		print(vim.inspect(node and --[[ node:named_child(0):type() ]]vim.treesitter.get_node_text(node:named_child(0),bufnr or 0)))
		--
		return node
	end
}

return builtin
