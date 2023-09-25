local util = require("nvim-dox.config.util")
local parser = require("nvim-dox.parser")
local user_config = require("nvim-dox.config").user_field

local M = {}

---generate the correct docstring
---@param type nvim_dox.type
---@param node TSNode | nil
---@param bufrn number
---@return boolean
M.generate = function(type, node, bufrn)
	local generator = util.get_avaliable_engine(bufrn)
	if generator == nil then
		return false
	end
	local row, col = util.get_output_start_loc(bufrn, type, generator.location[type], node)

	local docstring = { "" }
	if generator.style == "line" then
		docstring = M.generate_line(type, node, generator.style_config, generator.docstring[type])
	elseif generator.style == "block" then
		docstring = M.generate_block(type, node, generator.style_config, generator.docstring[type])
	elseif generator.style == "banner" then
		docstring = M.generate_banner(type, node, generator.style_config, generator.docstring[type])
	end
	return M.docstring_output(docstring, row, col)
end

---@alias generator_function fun(type: nvim_dox.type, node: TSNode | nil | boolean, style: nvim_dox.config.style_config, template: nvim_dox.docstring.template): string[]

---@type generator_function
---generate the docstring by line comment
---@param type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@return string[]
M.generate_line = function(type, node, style, template)
	local docstring = {}
	for _, line in pairs(template) do
		local _line = style.comment_line
		if line.keyword then
			_line = _line .. style.keyword_prefix .. line.keyword .. " "
		end
		_line = _line .. line.value
		if line[1] then
			_line = string.format(
				_line,
				parser.parsers[type][line[1]] and parser.parsers[type][line[1]](node)
					or user_config[line[1]] and user_config[line[1]]()
					or ""
			)
		end
		table.insert(docstring, _line)
	end

	return docstring
end

---@type generator_function
---generate the docstring by block comment
---@param type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@return string[]
M.generate_block = function(type, node, style, template)
	local docstring = M.generate_line(type, node, style, template)
	table.insert(docstring, 1, style.comment_head)
	table.insert(docstring, style.comment_tail)
	return docstring
end

---@type generator_function
---generate the docstring by banner comment
---@param type nvim_dox.type
---@param node TSNode|nil
---@param style nvim_dox.config.style_config
---@param template nvim_dox.docstring.template
---@return string[]
M.generate_banner = function(type, node, style, template)
	local docstring = M.generate_block(type, node, style, template)
	table.insert(docstring, 1, style.comment_prefix)
	table.insert(docstring, style.comment_suffix)
	return docstring
end

---insert the docstring to the buffer
---@param docstring table<string>
---@param row integer
---@param col integer
---@return boolean
M.docstring_output = function(docstring, row, col)
	local snippet_engine = util.get_snippets_functions()
	if snippet_engine == nil then
		-- insert the docstring to the buffer
		-- TODO: inline comments
		vim.api.nvim_buf_set_lines(0, row, row, false, docstring)
		return true
	end
	local count = 0
	local _docstring = table.concat(docstring, "\n"):gsub("%${(.-)}", function(matched)
		count = count + 1
		return "${" .. count .. ":" .. matched .. "}"
	end) .. "\n"
	print(_docstring)


	--TODO: a wierd bug when outputing, it automatically add a new line
	snippet_engine.expand(
		snippet_engine.snippet(
			"",
			snippet_engine.parse(nil, _docstring, { trim_empty = false, dedent = false })
		),
		{ pos = { row, col } }
	)
	return true
end

return M
