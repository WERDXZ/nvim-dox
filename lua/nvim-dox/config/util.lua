local config = require("nvim-dox.config")

local M = {}

---get the avaliable engine for the current buffer
---@param bufnr number
---@return nvim_dox.config.source|nil
M.get_avaliable_engine = function(bufnr)
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	for _, value in pairs(config.engines) do
		for _, v in pairs(value.ft) do
			if v == ft then
				return value
			end
		end
	end
	return nil
end

---get the output of the start location
---@param bufnr number
---@param type nvim_dox.type
---@param location nvim_dox.location|nil
---@param node TSNode | nil
---@return number, number
M.get_output_start_loc = function(bufnr, type, location, node)
	local loc = location or config.default_locations[type]
	local row, col = 0, 0
	if node then
		row, col = node:range()
	end
	if loc == "top" then
		return 0, 0
	elseif loc == "bottom" then
		return vim.api.nvim_buf_line_count(bufnr), 0
	elseif loc == "above" then
		return row, 0
	elseif loc == "below" then
		return row + 1, 0
	elseif loc == "after" then
		return row, vim.fn.col("$") - 1
	end

	return 0, 0
end

---get the snippet functions
---@class nvim_dox.snippet_functions
---@field parse any
---@field expand any
---@field snippet any
---
---@return nvim_dox.snippet_functions|nil
M.get_snippets_functions = function()
	local snippet_engine = config.snippet_engine
	if snippet_engine == nil then
		return nil
	end
	-- only support luasnip for now
	-- TODO: support other snippet engine
	return {
		parse = require(snippet_engine).parser.parse_snippet,
		expand = require(snippet_engine).snip_expand,
		snippet = require(snippet_engine).snippet,
	}
end

return M
