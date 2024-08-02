---Return the size of this character in bytes in UTF-8.
---@param char string The first byte of a character.
local function char_size(char)
  local first = char:byte()
  -- https://en.wikipedia.org/wiki/UTF-8#Encoding
  if bit.band(first, 0xf8) == 0xf0 then
    return 4
  elseif bit.band(first, 0xf0) == 0xe0 then
    return 3
  elseif bit.band(first, 0xe0) == 0xc0 then
    return 2
  else
    return 1
  end
end

-- https://en.wikipedia.org/wiki/Box-drawing_characters#Block_Elements
local nvim_logo = {
  "       ▄█🬱                 █▄       ",
  "     ▄  █ 🬁🬬               █  ▄     ",
  "   ▄    █   🬱              █    ▄   ",
  " ▄🬊     █    🬁🬬            █      ▄ ",
  "█  🬁🬬   █      🬱           █       █",
  "█    🬊  █       🬁🬬         █       █",
  "█     🬁🬬█         🬱        █       █",
  "█       🬊          🬁🬬      █       █",
  "█       █🬁🬬          🬱     █       █",
  "█       █  🬊          🬁🬬   █       █",
  "█       █   🬁🬬          🬱  █       █",
  "█       █     🬊          🬁🬬█       █",
  "█       █      🬁🬬          🬱       █",
  "█       █        🬊         █🬁🬬     █",
  "█       █         🬁🬬       █  🬱    █",
  "█       █           🬊      █   🬁🬬  █",
  " ▄      █            🬁🬬    █     🬱▄ ",
  "   ▄    █              🬊   █    ▄   ",
  "     ▄  █               🬁🬬 █  ▄     ",
  "       ▄█                 🬊█▄       ",
}
local nvim_colors = {
  "       LLG                 GG       ",
  "     LllLggg               GggG     ",
  "   LllllLgggG              GggggG   ",
  " B1lllllLgggggg            GggggggG ",
  "Bbb11lllLggggggG           GgggggggG",
  "Bbbbb1llLggggggggg         GgggggggG",
  "Bbbbbb11LgggggggggG        GgggggggG",
  "Bbbbbbbb1gggggggggggg      GgggggggG",
  "BbbbbbbbBGGggggggggggG     GgggggggG",
  "BbbbbbbbB  Ggggggggggggg   GgggggggG",
  "BbbbbbbbB   GGggggggggggG  GgggggggG",
  "BbbbbbbbB     GggggggggggggGgggggggG",
  "BbbbbbbbB      GGgggggggggg2gggggggG",
  "BbbbbbbbB        GgggggggggL33gggggG",
  "BbbbbbbbB         GGgggggggLll2ggggG",
  "BbbbbbbbB           GggggggLlll33ggG",
  " bbbbbbbB            GGggggLlllll2g ",
  "   bbbbbB              GgggLlllll   ",
  "     bbbB               GGgLlll     ",
  "       bB                 GLl       ",
}

local function render_window()
  -- How to make a window:
  -- https://www.statox.fr/posts/2021/03/breaking_habits_floating_window/
  local height = 22
  local width = 38
  local buffer = vim.api.nvim_create_buf(false, true)
  local ui = vim.api.nvim_list_uis()[1]
  local window = vim.api.nvim_open_win(buffer, false, {
    relative = "editor",
    row = (ui.height - height) / 2,
    col = (ui.width - width) / 2,
    height = height,
    width = width,
    anchor = "NW",
    focusable = false,
  })

  -- Center the subtext
  local subtext = "Neovim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
  local padding = (width - #subtext) / 2
  subtext = (" "):rep(padding) .. subtext

  vim.api.nvim_buf_set_lines(buffer, 0, height, false, nvim_logo)
  vim.api.nvim_buf_set_lines(buffer, height, -1, false, { "", subtext })
  vim.api.nvim_buf_call(buffer, function()
    vim.opt_local.cursorcolumn = false
    vim.opt_local.cursorline = false
    vim.opt_local.list = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    local bg = "#000000"
    local blue = "#0e69a6"
    local green = "#5d983c"
    local l_green = "#59a44e"

    vim.cmd.highlight("NvimLogoBlue guibg=" .. blue .. " guifg=" .. bg)
    vim.cmd.highlight("NvimLogoBlueInv guifg=" .. blue .. " guibg=" .. bg)
    vim.cmd.highlight("NvimLogoGreen guibg=" .. green .. " guifg=" .. bg)
    vim.cmd.highlight("NvimLogoGreenInv guifg=" .. green .. " guibg=" .. bg)
    vim.cmd.highlight("NvimLogoLGreen guibg=" .. l_green .. " guifg=" .. bg)
    vim.cmd.highlight("NvimLogoLGreenInv guifg=" .. l_green .. " guibg=" .. bg)
    vim.cmd.highlight("NvimLogoMix1 guifg=" .. l_green .. " guibg=" .. blue)
    vim.cmd.highlight("NvimLogoMix2 guifg=" .. l_green .. " guibg=" .. green)
    vim.cmd.highlight("NvimLogoMix3 guifg=" .. green .. " guibg=" .. l_green)
    vim.api.nvim_set_option_value("winhighlight", "Normal:Normal", { win = window })

    -- Map letters in the color map to highlight names
    local letter_to_name = {
      b = "Blue",
      B = "BlueInv",
      g = "Green",
      G = "GreenInv",
      l = "LGreen",
      L = "LGreenInv",
      ["1"] = "Mix1",
      ["2"] = "Mix2",
      ["3"] = "Mix3",
    }

    -- Color each character
    for y, row in ipairs(nvim_colors) do
      -- Characters in buffers are byte addressed, which is challenging for
      -- non-ASCII characters, like those used in the logo
      local logo_byte = 1

      for x = 1, #row do
        local printed_char = nvim_logo[y]:sub(logo_byte, logo_byte)
        local char = row:sub(x, x)
        if letter_to_name[char] then
          vim.fn.matchaddpos("NvimLogo" .. letter_to_name[char], { { y, logo_byte } })
        end
        -- The next character may be more than one byte away
        logo_byte = logo_byte + char_size(printed_char)
      end
    end
  end)

  -- Setup the correct event handlers to make this behave like `:intro`
  local vim_resized = false
  local autocmd
  autocmd = vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePre", "WinResized", "VimResized" }, {
    callback = function(ev)
      if ev.event == "VimResized" then
        -- Recenter when Vim resizes
        vim_resized = true
        ui = vim.api.nvim_list_uis()[1]
        vim.api.nvim_win_set_config(window, {
          relative = "editor",
          row = (ui.height - height) / 2,
          col = (ui.width - width) / 2,
        })
      elseif ev.event == "WinResized" and vim_resized then
        -- Don't close when a window resized because Vim resized
        vim_resized = false
      else
        vim.api.nvim_del_autocmd(autocmd)
        if vim.api.nvim_win_is_valid(window) then
          vim.api.nvim_win_close(window, true)
          vim.api.nvim_buf_delete(buffer, {})
        end
      end
    end,
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- https://vi.stackexchange.com/a/715
    -- Don't run if: we have commandline arguments, we don't have an empty
    -- buffer, if we've not invoked as vim or gvim, or if we'e start in insert mode
    if
      vim.fn.argc() ~= 0
      or vim.fn.line2byte(vim.fn.line("$")) ~= -1
      or vim.v.progname ~= "nvim"
      or vim.fn.mode() == "i"
    then
      return
    end

    -- Disable the normal `:intro` message
    vim.o.shortmess = vim.o.shortmess .. "I"
    render_window()
  end,
  once = true,
})
