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

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>")
vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>")
vim.keymap.set("n", "<leader>mR", ":MoltenReevaluateCell<CR>")
vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv")
vim.keymap.set("n", "<leader>mj", ":noautocmd MoltenEnterOutput<CR>")
vim.keymap.set("n", "<leader>mk", ":MoltenHideOutput<CR>")
vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>")

require("molten").setup({

})



