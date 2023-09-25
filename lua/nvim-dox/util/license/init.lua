local M = {}

---@type table<string, string>
M.licenses = {}

---register a license
---@param license string
---@param text string
M.register = function(license, text)
	M.licenses[license] = text
end

M.complete = function()
	local licenses = {}
	for license, _ in pairs(M.licenses) do
		table.insert(licenses, license)
	end
	return licenses
end

return M
