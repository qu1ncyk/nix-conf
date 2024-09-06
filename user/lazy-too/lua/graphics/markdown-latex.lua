local magick = require("magick")
local from_nix = require("lazy.from-nix")

local M = {}
---@cast M FileTypeHandler

---Find all LaTeX equations in a given buffer.
function M.scanner(buf)
  local parser = vim.treesitter.get_parser(buf, "markdown_inline")
  local syntax_tree = parser:parse()
  local root = syntax_tree[1]:root()

  local query = vim.treesitter.query.parse("markdown_inline", "(latex_block) @latex")

  local latex_blocks = {}
  for _, matches in query:iter_matches(root, buf) do
    local latex_code = vim.treesitter.get_node_text(matches[1], buf)
    local _, _, end_row, end_col = vim.treesitter.get_node_range(matches[1])

    table.insert(latex_blocks, {
      data = latex_code:gsub("^%$*", ""):gsub("%$*$", ""),
      row = end_row,
      col = end_col,
    })
  end
  return latex_blocks
end

---Render this LaTeX equation.
function M.loader(_, latex_code)
  local output = vim.system({ from_nix.plugins.mathjax .. "/bin/tex2svg", latex_code }):wait()
  local path = "/tmp/latex" .. math.random() .. ".svg"
  local svg = output.stdout
  assert(svg)

  -- Scale the dimensions
  svg = svg
    :gsub('%w+="[%d.]+ex"', function(s)
      return s:gsub("[%d.]+", function(n)
        return tonumber(n) * 2
      end)
    end, 2)
    -- Make the equation dark mode
    :gsub(
      "</defs>",
      [[
        </defs>,
        <g color="white">
        <rect width="99999" height="99999" fill="black" y="-50000" />
      ]],
      1
    )
    :gsub("</svg>", "</g></svg>", 1)
  local f = io.open(path, "w")
  assert(f)
  f:write(svg)
  f:close()

  local img = magick.load_image(path)
  vim.uv.fs_unlink(path)
  return img
end

return M
