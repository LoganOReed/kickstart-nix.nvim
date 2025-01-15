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
})

require("luasnip.loaders.from_lua").lazy_load({
paths = {"/home/occam/dotfiles/modules/home-manager/nvim/luasnip"}
})




vim.keymap.set({"i", "s"}, "<C-j>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-k>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, {silent = true})
