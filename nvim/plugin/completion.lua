if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local lspkind = require('lspkind')

-- require("cmp_nvim_ultisnips").setup{}
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')


vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

---@param source string|table
local function complete_with_source(source)
  if type(source) == 'string' then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == 'table' then
    cmp.complete { config = { sources = { source } } }
  end
end

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
    -- autocomplete = false,
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      with_text = true,
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      menu = {
        buffer = '[BUF]',
        nvim_lsp = '[LSP]',
        nvim_lsp_signature_help = '[LSP]',
        nvim_lsp_document_symbol = '[LSP]',
        nvim_lua = '[API]',
        path = '[PATH]',
        -- luasnip = '[SNIP]',
        ultisnips = '[SNIP]',
      },
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
 	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		-- ["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<C-l>"] = cmp.mapping(function(fallback)
      if vim.fn["UltiSnips#CanExpandSnippet"]() then
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
      elseif vim.fn["UltiSnips#CanJumpForwards"]() then
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
      elseif check_backspace() then
        cmp.complete()
      else
        fallback()
      end
    end,
      {
			"i",
			"s",
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
     if vim.fn["UltiSnips#CanJumpForwards"]() then
        cmp_ultisnips_mappings.jump_forwards(fallback)
      elseif vim.fn["UltiSnips#CanExpandSnippet"]() then
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
      else
        fallback()
      end
    end,
      {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["UltiSnips#CanJumpBackwards"]() then
        cmp_ultisnips_mappings.jump_backwards(fallback)
      else
        fallback()
      end
    end,
      {
			"i",
			"s",
		}),


  },
  sources = cmp.config.sources {
    -- The insertion order influences the priority of the sources
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'nvim_lsp_signature_help', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'ultisnips' },
    -- { name = 'luasnip' }, --dunno if thisll break things
  },
  enabled = function()
    return vim.bo[0].buftype ~= 'prompt'
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup.filetype('lua', {
  sources = cmp.config.sources {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'path' },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})

vim.keymap.set({ 'i', 'c', 's' }, '<C-n>', cmp.complete, { noremap = false, desc = '[cmp] complete' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-f>', function()
  complete_with_source('path')
end, { noremap = false, desc = '[cmp] path' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-o>', function()
  complete_with_source('nvim_lsp')
end, { noremap = false, desc = '[cmp] lsp' })
vim.keymap.set({ 'c' }, '<C-h>', function()
  complete_with_source('cmdline_history')
end, { noremap = false, desc = '[cmp] cmdline history' })
vim.keymap.set({ 'c' }, '<C-c>', function()
  complete_with_source('cmdline')
end, { noremap = false, desc = '[cmp] cmdline' })




  -- mapping = {
  --   ['<C-b>'] = cmp.mapping(function(_)
  --     if cmp.visible() then
  --       cmp.scroll_docs(-4)
  --     else
  --       complete_with_source('buffer')
  --     end
  --   end, { 'i', 'c', 's' }),
  --   ['<C-f>'] = cmp.mapping(function(_)
  --     if cmp.visible() then
  --       cmp.scroll_docs(4)
  --     else
  --       complete_with_source('path')
  --     end
  --   end, { 'i', 'c', 's' }),
  --   ['<C-n>'] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_next_item()
  --     -- expand_or_jumpable(): Jump outside the snippet region
  --     -- expand_or_locally_jumpable(): Only jump inside the snippet region
  --     elseif luasnip.expand_or_locally_jumpable() then
  --       luasnip.expand_or_jump()
  --     elseif has_words_before() then
  --       cmp.complete()
  --     else
  --       fallback()
  --     end
  --   end, { 'i', 'c', 's' }),
  --   ['<C-p>'] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_prev_item()
  --     elseif luasnip.jumpable(-1) then
  --       luasnip.jump(-1)
  --     else
  --       fallback()
  --     end
  --   end, { 'i', 'c', 's' }),
  --   -- toggle completion
  --   ['<C-e>'] = cmp.mapping(function(_)
  --     if cmp.visible() then
  --       cmp.close()
  --     else
  --       cmp.complete()
  --     end
  --   end, { 'i', 'c', 's' }),
  --   ['<C-y>'] = cmp.mapping.confirm {
  --     select = true,
  --   },
  -- },
