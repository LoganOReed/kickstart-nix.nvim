local ok, _ = pcall(require, 'luasnip')
if not ok then
  -- not loaded
  return
end

if vim.g.did_load_luasnip_plugin then
  return
end
vim.g.did_load_luasnip = true

local ls = require("luasnip")
local spath = "/home/occam/dotfiles/modules/home-manager/nvim/luasnip"

require('luasnip').setup({
-- snip_env = {
-- 		s = function(...)
-- 			local snip = require("luasnip").s(...)
-- 			-- we can't just access the global `ls_file_snippets`, since it will be
-- 			-- resolved in the environment of the scope in which it was defined.
-- 			table.insert(getfenv(2).ls_file_snippets, snip)
-- 		end,
-- 		parse = function(...)
-- 			local snip = require("luasnip").parser.parse_snippet(...)
-- 			table.insert(getfenv(2).ls_file_snippets, snip)
-- 		end,
-- 	},
})
require('luasnip').config.setup({
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  history = false,
  updateevents = "TextChanged, TextChangedI",
  delete_check_events = "TextChanged",
  ft_func = require("luasnip.extras.filetype_functions").from_cursor,
})

require("luasnip.loaders.from_lua").lazy_load({
paths = {spath},
fs_event_providers = {
  autocmd = true,
  libuv = true,
},
})




vim.keymap.set({"i", "s"}, "<C-k>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})


-- Function to open Oil in a right-side split
local function open_oil_in_split()
  local filetype = vim.bo.filetype
  if not filetype or filetype == "" then
    print("No filetype detected for the current buffer.")
    return
  end

  local target_dir = spath .. "/" .. filetype

  -- Ensure the directory exists, create it if it doesn't
  if vim.fn.isdirectory(target_dir) == 0 then
    vim.fn.mkdir(target_dir, "p")
    print("Created directory: " .. target_dir)
  end
  local width = math.floor(vim.o.columns / 2) -- Half the screen width

  -- Open a vertical split and resize to occupy half the screen
  vim.cmd("vsplit")
  vim.cmd("vertical resize " .. width)

  -- Open Oil at the specified directory
  vim.cmd("Oil " .. target_dir)
end

-- Keybinding to open Oil in the right half of the screen
vim.keymap.set("n", "<leader>sl", open_oil_in_split, { desc = "Open window to edit luasnip" })
