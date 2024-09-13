local config_root = require("lazy.from-nix").lazy.config_root
return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  config = function()
    require("luasnip").setup({})
    require("luasnip.loaders.from_lua").lazy_load({ paths = config_root .. "/lua/snippets" })
  end,
}
