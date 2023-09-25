local M = {}

---return the parent node with the first matching name
---@param node TSNode|nil
---@param names string[]
M.get_named_parent = function(node, names)
	local max_iter = require("nvim-dox.config").max_iter
	local iter = 0
	if node == nil then
		return nil
	end
	while iter < max_iter do
		for _, name in ipairs(names) do
			if node:type() == name then
				return node
			end
		end
		iter = iter + 1
		node = node:parent()
		if node == nil then
			return nil
		end
	end
end

return M
