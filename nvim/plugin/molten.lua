local status_ok, molten = pcall(require, "molten")
if not status_ok then
  return
end

if vim.g.did_load_molten_plugin then
  return
end
vim.g.did_load_molten_plugin = true


vim.g.molten_image_provider = "image.nvim"
vim.g.molten_use_border_highlights = true

require("molten").setup({

})


vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>")
vim.keymap.set("n", "<localleader>me", ":MoltenEvaluateOperator<CR>")
vim.keymap.set("n", "<localleader>mR", ":MoltenReevaluateCell<CR>")
vim.keymap.set("v", "<localleader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv")
vim.keymap.set("n", "<localleader>mj", ":noautocmd MoltenEnterOutput<CR>")
vim.keymap.set("n", "<localleader>mk", ":MoltenHideOutput<CR>")
vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>")
