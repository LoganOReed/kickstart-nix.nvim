local status_ok, jupytext = pcall(require, "jupytext")
if not status_ok then
  return
end

if vim.g.did_load_jupytext_plugin then
  return
end
vim.g.did_load_jupytext_plugin = true

require("jupytext").setup({
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
})
