---@class Set
---@field values table<any, boolean>
local Set = {}

---@return Set
function Set.new()
  local self = setmetatable({}, { __index = Set })
  self.values = {}
  return self
end

function Set:add(value)
  self.values[value] = true
end

function Set:remove(value)
  self.values[value] = nil
end

function Set:has(value)
  return self.values[value] == true
end

---Convert a list to a `Set`.
---@param list any[]
---@return Set
function Set.from(list)
  local self = Set.new()
  for _, value in ipairs(list) do
    self:add(value)
  end
  return self
end

---Return an iterator that iterates over the values in the `Set`.
function Set:iter()
  return pairs(self.values)
end

return Set
