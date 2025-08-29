if vim.g.did_load_vimtex_plugin then
  return
end
vim.g.did_load_vimtex_plugin = true

local g = vim.g

g.vimtex_view_method = "zathura"
g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
g.vimtex_motion_enabled = 1
g.vimtex_matchparen_enabled = 0
g.vimtex_fold_enabled = 1
g.tex_conceal = 'abdmg'
-- g.vimtex_fold_manual = 1
