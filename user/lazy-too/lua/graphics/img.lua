local escape = require("graphics.escape")

local base64 = require("image.utils.base64")
local term = require("image.utils.term")

---@class Img
---@field img MagickImage
---@field id integer
---@field cols integer
---@field rows integer
---@field ctx ImgCtx
local Img = {}

---@param img MagickImage
---@param ctx ImgCtx
---@return table|Img
function Img.new(img, ctx)
  local self = setmetatable({}, { __index = Img })

  self.img = img
  self.img:set_depth(8)
  self.img:set_format("RGBA")
  self.id = math.random(math.pow(2, 32)) - 1
  self.cols = self.img:get_width() / term.get_size().cell_width
  self.rows = self.img:get_height() / term.get_size().cell_height
  self.ctx = ctx
  self:resize()
  self:transmit()
  self:highlight()

  return self
end

---Create a new highlight group for this `Img`.
function Img:highlight()
  local value = bit.band(self.id, 0xffffff)
  vim.api.nvim_set_hl(self.ctx.ns, tostring(self.id), {
    fg = string.format("#%06x", value),
  })
end

---Transmit this `Img` to Kitty.
function Img:transmit()
  local path = "/tmp/tty-graphics-protocol-" .. self.id .. ".rgba"
  self.img:write(path)
  io.stdout:write(
    escape.esc
      .. "_Ga=T,U=1,t=t,q=2,i="
      .. self.id
      .. ",s="
      .. self.img:get_width()
      .. ",v="
      .. self.img:get_height()
      .. ",c="
      .. self.cols
      .. ",r="
      .. self.rows
      .. ";"
      .. base64.encode(path)
      .. escape.esc
      .. "\\"
  )
end

---Generate the virtual lines for the extmark that belongs to this `Img`.
function Img:virt_lines()
  local lines = {}
  local hl_group = tostring(self.id)
  for y = 1, self.rows do
    if y > #escape.diacritics then
      break
    end
    local line = ""
    for x = 1, self.cols do
      if x > #escape.diacritics then
        break
      end
      line = line
        .. escape.placeholder
        .. escape.diacritics[y]
        .. escape.diacritics[x]
        .. escape.diacritics[bit.rshift(self.id, 24) + 1]
    end
    table.insert(lines, { { line, hl_group } })
  end
  return lines
end

---Resize the `Img` to make it at most as large as the maximal size.
function Img:resize()
  local rows = self.rows
  local cols = self.cols
  local max_rows = self.ctx.max_size.rows
  local max_cols = self.ctx.max_size.cols

  if max_cols and cols > max_cols then
    rows = rows / cols * max_cols
    cols = max_cols
  end
  if max_rows and rows > max_rows then
    cols = cols / rows * max_rows
    rows = max_rows
  end

  self.rows = math.ceil(rows)
  self.cols = math.ceil(cols)
end

---Remove this `Img` from Kitty's memory.
function Img:delete()
  io.stdout:write(escape.esc .. "_Ga=d,i=" .. self.id .. escape.esc .. "\\")
  self.img:destroy()
end

return Img
