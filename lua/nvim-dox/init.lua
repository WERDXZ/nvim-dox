local M = {}

M.api = {}
M.api.querier = require("nvim-dox.querier")
M.api.parser = require("nvim-dox.parser")
M.api.type = require("nvim-dox.type")

M.setup = function (opts)
	require("nvim-dox.excecutor").setup()
	require("nvim-dox.config.setup")(opts)
	print(vim.inspect(opts))
end

return M
