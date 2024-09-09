vim.api.nvim_create_user_command("DapUI", function(c)
  if c.args == "open" then
    require("dapui").open()
  elseif c.args == "close" then
    require("dapui").close()
  else
    require("dapui").toggle()
  end
end, {
  complete = function()
    return { "open", "close" }
  end,
  nargs = "?",
})
