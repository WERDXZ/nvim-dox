local user_config = require("nvim-dox.config").user_field
local util = require("nvim-dox.config.util")
local parser = require("nvim-dox.parser")

local M = {}

---generate the correct docstring
---@param type nvim_dox.type
---@param node TSNode | nil
---@param bufnr number
---@return boolean
M.generate = function(type, node, bufnr)
	local generator = util.get_avaliable_engine(bufnr)
	if generator == nil then
		return false
	end
	if generator.docstring[type] == nil then
		return false
	end
	local row, col = util.get_output_start_loc(bufnr, type, generator.location[type], node)

	local docstring = { "" }
	if generator.style == "line" then
		docstring = M.generate_line(type, node, generator.style_config, generator.docstring[type], bufnr)
	elseif generator.style == "block" then
		docstring = M.generate_block(type, node, generator.style_config, generator.docstring[type], bufnr)
	elseif generator.style == "banner" then
		docstring = M.generate_banner(type, node, generator.style_config, generator.docstring[type], bufnr)
	end
	return M.docstring_output(docstring, row, col, bufnr)
end

---@alias generator_function fun(node_type: nvim_dox.type, node: TSNode | nil | boolean, style: nvim_dox.config.style_config, template: nvim_dox.docstring.template, bufnr: integer): string[]
---all these functions are used to generate the docstring which is strings in a list

---@type generator_function
---generate the docstring by line comment
---@param node_type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@param bufnr integer
---@return string[] 
M.generate_line = function(node_type, node, style, template, bufnr)
	local docstring = {}
	local parsers = vim.deepcopy(parser.parsers[node_type])
	for key, value in pairs(user_config) do
		parsers[key] = value
	end

	for _, line in pairs(template) do
		local _line = style.comment_line
		if line.keyword then
			_line = _line .. style.keyword_prefix .. line.keyword .. " "
		end
		_line = _line .. line.value

		-- Check if there is a special parser for the current line
		local parsedValue = nil
		if line[1] then
			local parserItem = parsers[line[1]]
			if type(parserItem) == "function" then
				parsedValue = parserItem(node, bufnr)
				if parsedValue == nil then goto continue end
			else
				parsedValue = parserItem
			end

			-- Default to empty string if neither parser nor user_config has the value
			if not parsedValue then
				parsedValue = ""
			end
		end

		-- Check if the parsed value is a table and handle it
		if type(parsedValue) == "table" then
			for _, value in pairs(parsedValue) do
				table.insert(docstring, string.format(_line, value))
			end
		else
			table.insert(docstring, string.format(_line, parsedValue))
		end

		if line.newline then
			table.insert(docstring, style.comment_line)
		end

		::continue::
	end

	return docstring
end

---@type generator_function
---generate the docstring by block comment
---@param node_type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@param bufnr integer
---@return string[]
M.generate_block = function(node_type, node, style, template, bufnr)
	local docstring = M.generate_line(node_type, node, style, template, bufnr)
	table.insert(docstring, 1, style.comment_head)
	table.insert(docstring, style.comment_tail)
	return docstring
end

---@type generator_function
---generate the docstring by banner comment
---@param node_type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@param bufnr integer
---@return string[]
M.generate_banner = function(node_type, node, style, template, bufnr)
	local docstring = M.generate_block(node_type, node, style, template, bufnr)
	table.insert(docstring, 1, style.comment_prefix)
	table.insert(docstring, style.comment_suffix)
	return docstring
end

---insert the docstring to the buffer
---@param docstring table<string>
---@param row integer
---@param col integer
---@param bufnr integer
---@return boolean
M.docstring_output = function(docstring, row, col, bufnr)
	local snippet_engine = util.get_snippets_functions()
	if snippet_engine == nil then
		-- insert the docstring to the buffer
		-- TODO: inline comments
		vim.api.nvim_buf_set_lines(bufnr, row, row, false, docstring)
		return true
	end
	local count = 0
	local _docstring = table.concat(docstring, "\n"):gsub("%${(.-)}", function(matched)
		count = count + 1
		return "${" .. count .. ":" .. matched .. "}"
	end)

	vim.fn.append(row,"")
	--TODO: a wierd bug when outputing, it automatically add a new line
	snippet_engine.expand(
		snippet_engine.snippet("", snippet_engine.parse(nil, _docstring, { trim_empty = false, dedent = false })),
		{ pos = { row, col } }
	)
	return true
end

return M
