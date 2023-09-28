local config = require("nvim-dox.config")

---join the config with opts
---@param opts nvim_dox.config
local function setup(opts)
	if opts == nil then
		return
	end
	for _, value in ipairs(opts.engines or {}) do
		table.insert(config.engines, value)
	end
	config.max_iter = opts.max_iter and type(opts.max_iter)=="number" and opts.max_iter or 5
	config.register_keywords = opts.register_keywords and true
	config.short_license = opts.short_license and true
	config.snippet_engine = opts.snippet_engine

	for key, value in ipairs(opts.user_field or {}) do
		if type(value) == "function" then
			config.user_field[key] = value
		end
	end
	for key, value in pairs(opts.default_locations or {}) do
		config.default_locations[key] = value
	end
end

return setup
