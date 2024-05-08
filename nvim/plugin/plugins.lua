if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('which-key').setup()
--require("wf").setup()
require("dracula").setup()
require("oil").setup()
require("better_escape").setup({timeout = 200,})
require("todo-comments").setup()
require("nvim-autopairs").setup()
require('leap').create_default_mappings()
require("nvim_comment").setup()
require("persisted").setup()
require('nvim-highlight-colors').setup({})
