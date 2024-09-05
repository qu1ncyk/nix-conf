local magick = require("magick")

local M = {}
---@cast M FileTypeHandler

---Find all images in a given buffer.
function M.scanner(buf)
  local parser = vim.treesitter.get_parser(buf, "markdown_inline")
  local syntax_tree = parser:parse()
  local root = syntax_tree[1]:root()

  local query = vim.treesitter.query.parse("markdown_inline", "(image (link_destination) @url) @image")

  local images = {}
  for _, matches in query:iter_matches(root, buf) do
    local url = vim.treesitter.get_node_text(matches[1], buf)
    local _, _, end_row, end_col = vim.treesitter.get_node_range(matches[2])

    table.insert(images, {
      data = url,
      row = end_row,
      col = end_col,
    })
  end
  return images
end

---Convert a path relative to the path of the buffer to an absolute path.
---@param buf integer
---@param path string
local function resolve_path(buf, path)
  local parent_dir = vim.api.nvim_buf_call(buf, function ()
    return vim.fn.expand("%:p:h")
  end)
  return parent_dir .. "/" .. path
end

---Load the image from the URL.
function M.loader(buf, url)
  if not url:match("^/") and not url:match("^https?://") then
    url = resolve_path(buf, url)
  end

  return magick.load_image(url)
end

return M
