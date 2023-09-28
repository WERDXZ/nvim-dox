local M = {}

M.api = {}
M.api.querier = require("nvim-dox.querier")
M.api.parser = require("nvim-dox.parser")
M.api.type = require("nvim-dox.type")
M.api.generator = require("nvim-dox.generator")
M.api.util = require("nvim-dox.util")

M.setup = function (opts)
	require("nvim-dox.excecutor").setup()
	require("nvim-dox.config.setup")(opts)
end

return M




