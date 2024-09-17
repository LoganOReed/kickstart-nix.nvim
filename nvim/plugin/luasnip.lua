local ok, _ = pcall(require, 'luasnip')
if not ok then
  -- not loaded
  return
end

if vim.g.did_load_luasnip_plugin then
  return
end
vim.g.did_load_luasnip = true

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
paths = {"/home/occam/.snippets/luasnip"}
})


vim.api.nvim_set_keymap("i", "<C-f>", "<Plug>luasnip-jump-next", {})
