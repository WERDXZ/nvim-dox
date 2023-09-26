local get_named_child = require("nvim-dox.util").get_named_child

local builtin = {
	---@type nvim_dox.parser
	["file"] = {
		["name"] = function(_, bufnr)
			return vim.api.nvim_buf_get_name(bufnr):match("^.+/(.+)$")
		end,
		["modified_date"] = function(_, bufnr)
			-- local modified = vim.fn.getftime(filename)
			return vim.fn.strftime(vim.fn.getftime(vim.api.nvim_buf_get_name(bufnr))) or ""
		end,
	},
	---@type nvim_dox.parser
	["function"] = {
		["return"] = function(node, bufnr)
			if node and node:type() == "template_declaration" then
				node = node:named_child(1)
			end

			local return_node = node and get_named_child(node, { "type_identifier", "primitive_type" }) or nil
			if return_node then
				return vim.treesitter.get_node_text(return_node, bufnr)
			end
			return nil
		end,
		["params"] = function(node, bufnr)
			if node and node:type() == "template_declaration" then
				node = node:named_child(1)
			end

			local func_decl_node = node and get_named_child(node, { "function_declarator" }) or nil
			local params_node = func_decl_node and get_named_child(func_decl_node, { "parameter_list" }) or nil
			if params_node == nil then
				return nil
			end
			local params = {}
			for i = 0, params_node:named_child_count() - 1 do
				local param_decl = params_node:named_child(i)
				for j = 0, param_decl:named_child_count() - 1 do
					local child = param_decl:named_child(j)
					if child:type() == "identifier" then
						table.insert(params, vim.treesitter.get_node_text(child, bufnr))
					end
				end
			end
			return params
		end,
		["name"] = function(node, bufnr)
			if node and node:type() == "template_declaration" then
				node = node:named_child(1)
			end

			local func_decl_node = node and get_named_child(node, { "function_declarator" }) or nil
			local func_id_node = func_decl_node and get_named_child(func_decl_node, { "identifier" }) or nil

			if func_id_node == nil then
				return nil
			end

			return vim.treesitter.get_node_text(func_id_node, bufnr)
		end,
		["tparams"] = function(node, bufnr)
			local params_node = node and get_named_child(node, { "template_parameter_list" }) or nil
			if params_node == nil then
				return nil
			end
			local params = {}
			for i = 0, params_node:named_child_count() - 1 do
				local param_decl = params_node:named_child(i)
				for j = 0, param_decl:named_child_count() - 1 do
					local child = param_decl:named_child(j)
					if child:type() == "type_identifier" then
						table.insert(params, vim.treesitter.get_node_text(child, bufnr))
					end
				end
			end
			return params
		end,
	},
}

return builtin
