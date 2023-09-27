local M = {}

---return the parent node with the first matching name
---@param node TSNode|nil
---@param names string[]
---@param max_iter integer|nil
M.get_named_parent = function(node, names, max_iter)
	local _max_iter = max_iter or require("nvim-dox.config").max_iter
	local iter = 0
	if node == nil then
		return nil
	end
	while iter < _max_iter do
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

---get the first child node with the matching name 
---@param node TSNode
---@param names string[]
---@return unknown
M.get_named_child = function(node, names)
	for i = 0, node:named_child_count() - 1 do
		local child = node:named_child(i)
		for _, name in ipairs(names) do
			if child and  child:type() == name then
				return child
			end
		end
	end
	return nil
end

---raise a warning
---@param msg string
M.warn = function (msg)
	vim.notify(msg, vim.log.levels.WARN)
end

---raise an error
---@param msg string
M.error = function (msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

return M
