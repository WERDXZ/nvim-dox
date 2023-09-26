local license = require("nvim-dox.util.license")

---@class nvim_dox.config.source
---@field docstring nvim_dox.docstring.template
---@field style_config nvim_dox.config.style_config
---@field style "block"|"line"|"banner"
---@field ft string[]
---@field keywords string[]
---@field location table<nvim_dox.type, nvim_dox.location>
---
---@class nvim_dox.config.style_config
---@field comment_prefix string
---@field comment_suffix string
---@field comment_head string
---@field comment_line string
---@field comment_tail string
---@field keyword_prefix string
---
---@class nvim_dox.config
---@field engines nvim_dox.config.source[]
---@field max_iter integer
---@field register_keywords boolean
---@field short_license boolean
---@field snippet_engine string|nil
---@field user_field table<string, fun():string>
---@field default_locations table<nvim_dox.type, nvim_dox.location|table<integer>>

---@type nvim_dox.config
local M = {
	engines = {
		doxygen = require("nvim-dox.config.doxygen"),
	},
	max_iter = 5, -- max iteration for the query
	register_keywords = true, -- register keywords to cmp 
	short_license = true, -- it will output something like `This project is released under the ${LICENSE}.`
	snippet_engine = "luasnip",
	user_field = {
		author = function ()
			return "${author}"
		end,

		-- the license you might want to use, just find any license
		-- in require("license").licenses, just the key name
		license = function()
			local licenses = license.complete()
			local _license
			vim.ui.select(licenses, { prompt = "License"}, function(choice)
				_license = choice
			end)
			return _license
		end,
	},
	default_locations = {
		["file"] = "top",
		["function"] = "above",
		["class"] = "above",
		["struct"] = "above",
	},

}

return M;
