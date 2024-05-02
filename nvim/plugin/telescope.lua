if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
	      horizontal = {
		prompt_position = "top",
		preview_width = 0.55,
		results_width = 0.8,
	      },
	      vertical = {
		mirror = false,
	      },
	      width = 0.87,
	      height = 0.80,
	      preview_cutoff = 120,
    }


telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },


    layout_strategy = "horizontal",
    layout_config = layout_config,
	    mappings = {
	-- TODO: This doesn't work eight now
	      n = { ["q"] = require("telescope.actions").close },
	      i = {
		    ["<Down>"] = require("telescope.actions").cycle_history_next,
		    ["<Up>"] = require("telescope.actions").cycle_history_prev,
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
		    ["<C-j>"] = require("telescope.actions").move_selection_next,
		    ["<C-k>"] = require("telescope.actions").move_selection_previous,
	      },
	    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
	      "rg",
	      "-L",
	      "--color=never",
	      "--no-heading",
	      "--with-filename",
	      "--line-number",
	      "--column",
	      "--smart-case",
	    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension('fzy_native')
-- telescope.load_extension('smart_history')
