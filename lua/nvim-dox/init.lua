local M = {}

M.setup = function (opts)
	require("nvim-dox.excecutor").setup()
	require("nvim-dox.config.setup")(opts)
	require("nvim-dox.util.complete").setup()
end

return M
