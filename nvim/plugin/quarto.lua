if vim.g.did_load_quarto_plugin then
  return
end
vim.g.did_load_quarto_plugin = true

local status_ok, quarto = pcall(require, "project_nvim")
if not status_ok then
	return
end

quarto.setup({
    lspFeatures = {
        -- NOTE: put whatever languages you want here:
        languages = { "r", "python", "rust", "octave", "bash", "html" },
        chunks = "all",
        diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
        },
        completion = {
            enabled = true,
        },
    },
    keymap = {
        -- NOTE: setup your own keymaps:
        hover = "K",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
    },
    codeRunner = {
        enabled = true,
        default_method = "molten",
    },
})
