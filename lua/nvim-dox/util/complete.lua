local get_named_parent = require("nvim-dox.util").get_named_parent
local M = {}

local params = {}

params.keywords = {}
params.trigger = ""

---@param keywords table<string>
---@return table
local function transform_keywords(keywords)
	local transformed = {}
	for _, keyword in ipairs(keywords) do
		table.insert(transformed, { label = keyword })
	end
	return transformed
end


local function change_params(ev)
	local engine = require("nvim-dox.config.util").get_avaliable_engine(ev.buf)
	if engine == nil then
		return
	end
	params.keywords = transform_keywords(engine.keywords)
	params.trigger = engine.style_config.keyword_prefix
end

---check if the cursor is inside comment 
---@param bufnr number
---@return boolean|nil
local function check_inside_comment(bufnr)
	local node = get_named_parent(vim.treesitter.get_node({ bufnr = bufnr }), { "comment" })
	return node and node:type() == "comment"
end


---create and register completion source for cmp
---types from cmp.types
local function register_cmp()
	local source = {}

	function source:get_trigger_characters()
		return { params.trigger }
	end

	---Invoke completion (required).
	---@param p cmp.SourceCompletionApiParams
	---@param callback fun(response: lsp.CompletionResponse|nil)
	function source:complete(p, callback)
		callback(params.keywords)
	end

	require("cmp").register_source("nvim-dox", source)
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNew" }, {
		callback = function(ev)
			change_params(ev)
		end,
	})
	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
		callback = function(ev)
			change_params(ev)
			return true
		end,
	})
	register_cmp()
end

return M
