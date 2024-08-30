if vim.g.did_load_vimtex_plugin then
  return
end
vim.g.did_load_vimtex_plugin = true

local g = vim.g

g.vimtex_view_method = "zathura"
