local get_named_parent = require("nvim-dox.util").get_named_parent

---@type nvim_dox.querier_table
local builtin = {
	---@type nvim_dox.querier
	["file"] = function(_)
		-- if the cursor is at first line
		if vim.fn.line(".") == 1 then
			-- just get the node at cursor
			print("true yield")
			return true
		end
		return nil
	end,
	---@type nvim_dox.querier
	["function"] = function (bufnr)
		local func = {"function_definition","template_declaration"}
		local node = get_named_parent(vim.treesitter.get_node({bufnr=bufnr}), func)

		print(node and node:parent():type())
		print("seperator")

		if node and node:parent() and node:parent():type() == "template_declaration" then
			print("template_declaration")
			node = node:parent()
		end

		return node
	end
}

return builtin
