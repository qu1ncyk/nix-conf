-- Hack until I implement LuaRocks in lazy-too
-- Inspiration from running `nix build nixpkgs#vimPlugins.image-nvim`
local from_nix = require("lazy.from-nix")
package.path = package.path .. ";" .. from_nix.plugins.magick .. "/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. from_nix.plugins.magick .. "/share/lua/5.1/?.lua;"

local ImgCtx = require("graphics.img-ctx")

local M = {}

---@class BufData
---@field filetype string
---@field ctx ImgCtx
---@field augroup integer

---Add graphics capabilites to the given buffer if it doesn't already have
---them.
---@param buf integer
---@param handlers FTHandlerList
---@param max_size { rows: integer?, cols: integer? }
---@param filetype string
function M.attach_buffer(buf, handlers, max_size, filetype)
  if vim.b[buf].graphics then
    if vim.b[buf].graphics.filetype ~= filetype then
      -- Filetype changed, remove the old handlers
      M.detach_buffer(buf)
    else
      return
    end
  end

  local ctx = ImgCtx.new(buf, handlers, max_size)
  local augroup = vim.api.nvim_create_augroup("", {})
  ---@type BufData
  vim.b[buf].graphics = { filetype = filetype, ctx = ctx, augroup = augroup }

  ctx:rerender()
  vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    callback = function()
      ctx:rerender()
    end,
    buffer = buf,
    group = augroup,
  })

  vim.api.nvim_create_autocmd({ "BufUnload", "FileType" }, {
    callback = function(ev)
      if ev.event == "FileType" and ev.match == filetype then
        return
      end
      M.detach_buffer(buf)
    end,
    buffer = buf,
    group = augroup,
  })
end

---Remove graphics capabilites from the buffer.
---@param buf integer
function M.detach_buffer(buf)
  ---@type BufData
  local bufdata = vim.b[buf].graphics
  ImgCtx.destruct(bufdata.ctx)
  vim.api.nvim_del_augroup_by_id(bufdata.augroup)
  vim.b[buf].graphics = nil
end

---@class GraphicsOpts
---@field auto_start boolean?
---@field filetypes table<string, FTHandlerList | boolean>?
---@field max_size { rows: integer?, cols: integer? }?

---@alias FTHandlerList table<string | number, FileTypeHandler | boolean>

---@class FileTypeHandler
---@field scanner fun(buf: integer): { row: integer, col: integer, data: string }[]
---@field loader fun(buf: integer, data: string): MagickImage

---@type GraphicsOpts
M.graphic_opts_defaults = {
  auto_start = true,
  max_size = {},
  filetypes = {
    markdown = {
      image = require("graphics.markdown-image"),
    },
  },
}

---@param opts GraphicsOpts?
function M.setup(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, M.graphic_opts_defaults)
  if not opts.auto_start then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local handlers = opts.filetypes[ev.match]
      if type(handlers) == "table" then
        M.attach_buffer(ev.buf, handlers, opts.max_size, ev.match)
      end
    end,
  })
end

return M
