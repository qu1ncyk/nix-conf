local Img = require("graphics.img")
local Set = require("graphics.set")

---@class ImgCtx
---@field buf integer
---@field ns integer
---@field imgs table<integer, Img> Extmark ID -> Img
---@field handlers FTHandlerList
---@field data table<integer, string> Extmark ID -> data
---@field max_size { rows: integer?, cols: integer? }
local ImgCtx = {}

---@param buf integer
---@param handlers FTHandlerList
---@param max_size { rows: integer?, cols: integer? }
---@return ImgCtx
function ImgCtx.new(buf, handlers, max_size)
  local self = setmetatable({}, { __index = ImgCtx })

  self.buf = buf
  self.imgs = {}
  self.max_size = max_size

  self.ns = vim.api.nvim_create_namespace("image")
  vim.api.nvim_set_hl_ns(self.ns)

  self.handlers = handlers
  self.data = {}

  return self
end

---Add a new `Img` below the given line.
---@param magick_img MagickImage
---@param line integer Zero-based
---@param col integer?
function ImgCtx:add_below(magick_img, line, col)
  local img = Img.new(magick_img, self)
  local extmark = vim.api.nvim_buf_set_extmark(self.buf, self.ns, line, col or 0, {
    virt_lines = img:virt_lines(),
  })
  self.imgs[extmark] = img
  return extmark
end

---Delete an image at an extmark.
---@param extmark integer
function ImgCtx:delete_img(extmark)
  vim.api.nvim_buf_del_extmark(self.buf, self.ns, extmark)
  self.imgs[extmark]:delete()
  self.imgs[extmark] = nil
end

---Delete all extmarks, highlights and `Img`s of this buffer.
function ImgCtx:destruct()
  for _, img in ipairs(self.imgs) do
    img:delete()
  end
  vim.api.nvim_buf_clear_namespace(self.buf, self.ns, 0, -1)
end

---Scan the buffer and update the image previews.
function ImgCtx:rerender()
  local old_extmarks = Set.from(vim.tbl_map(function(extmark)
    return extmark[1]
  end, vim.api.nvim_buf_get_extmarks(self.buf, self.ns, 0, -1, {})))

  for _, handler in pairs(self.handlers) do
    local images = handler.scanner(self.buf)
    for _, image in ipairs(images) do
      local pos = { image.row, image.col }
      ---@type vim.api.keyset.get_extmark_item?
      local extmark = vim.api.nvim_buf_get_extmarks(self.buf, self.ns, pos, pos, {})[1]

      if extmark and image.data == self.data[extmark[1]] then
        -- Existing extmark is still relevant
        old_extmarks:remove(extmark[1])
      else
        -- Add new image preview
        local img = handler.loader(self.buf, image.data)
        if img then
          local new_extmark = self:add_below(img, pos[1], pos[2])
          self.data[new_extmark] = image.data
        end
      end
    end
  end

  -- Remove outdated extmarks
  for extmark_id in old_extmarks:iter() do
    self:delete_img(extmark_id)
    self.data[extmark_id] = nil
  end
end

return ImgCtx
