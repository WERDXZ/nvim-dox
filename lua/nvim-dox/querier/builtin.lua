local get_named_parent = require("nvim-dox.util").get_named_parent
local get_named_child = require("nvim-dox.util").get_named_child

---@type nvim_dox.querier_table
local builtin = {
	---@type nvim_dox.querier
	["file"] = function(_)
		-- if the cursor is at first line
		if vim.fn.line(".") == 1 then
			return true
		end
		return nil
	end,
	---@type nvim_dox.querier
	["function"] = function(bufnr)
		local func = { "function_definition", "template_declaration" }
		local node = get_named_parent(vim.treesitter.get_node({ bufnr = bufnr }), func)

		if
			node
			and node:type() == "template_declaration"
			and get_named_child(node, { "function_definition" }) == nil
		then
			return nil
		end

		if node and node:parent() and node:parent():type() == "template_declaration" then
			node = node:parent()
		end

		return node
	end,
	["class"] = function(bufnr)
		local class = { "template_declaration", "class_specifier" }
		local node = get_named_parent(vim.treesitter.get_node({ bufnr = bufnr }), class)
		if node and node:type() == "template_declaration" and get_named_child(node, { "class_specifier" }) == nil then
			return nil
		end

		if node and node:parent() and node:parent():type() == "template_declaration" then
			node = node:parent()
		end

		print(node and node:type() or "nil")

		return node
	end,
	["struct"] = function(bufnr)
		local struct = { "template_declaration", "struct_specifier" }
		local node = get_named_parent(vim.treesitter.get_node({ bufnr = bufnr }), struct)

		if node and node:type() == "template_declaration" and get_named_child(node, { "struct_specifier" }) == nil then
			return nil
		end

		if node and node:parent() and node:parent():type() == "template_declaration" then
			node = node:parent()
		end

		return node
	end,
}

return builtin
