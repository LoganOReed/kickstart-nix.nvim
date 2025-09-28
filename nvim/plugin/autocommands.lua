if vim.g.did_load_autocommands_plugin then
  return
end
vim.g.did_load_autocommands_plugin = true

local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal('noundofile')
  end,
})

-- Disable spell checking in terminal buffers
local nospell_group = api.nvim_create_augroup('nospell', { clear = true })
api.nvim_create_autocmd('TermOpen', {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

-- LSP
local keymap = vim.keymap

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  local buf, _ = vim.lsp.util.preview_location(result[1])
  if buf then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = vim.bo[cur_buf].filetype
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Attach plugins
    require('nvim-navic').attach(client, bufnr)

    vim.cmd.setlocal('signcolumn=yes')
    vim.bo[bufnr].bufhidden = 'hide'

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end
    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('lsp [g]o to [D]eclaration'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('lsp [g]o to [d]efinition'))
    keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('lsp [g]o to [t]ype definition'))
    -- Commented as ufo.nvim handles this and fold previews
    -- keymap.set('n', 'K', vim.lsp.buf.hover, desc('[lsp] hover'))
    keymap.set('n', '<space>pd', peek_definition, desc('lsp [p]eek [d]efinition'))
    keymap.set('n', '<space>pt', peek_type_definition, desc('lsp [p]eek [t]ype definition'))
    keymap.set('n', 'gi', vim.lsp.buf.implementation, desc('lsp [g]o to [i]mplementation'))
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('[lsp] signature help'))
    keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('lsp add [w]orksp[a]ce folder'))
    keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp [w]orkspace folder [r]emove'))
    keymap.set('n', '<space>wl', function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, desc('[lsp] [w]orkspace folders [l]ist'))
    keymap.set('n', '<space>rn', vim.lsp.buf.rename, desc('lsp [r]e[n]ame'))
    keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, desc('lsp [w]orkspace symbol [q]'))
    keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, desc('lsp [dd]ocument symbol'))
    keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, desc('[lsp] code action'))
    keymap.set('n', '<M-l>', vim.lsp.codelens.run, desc('[lsp] run code lens'))
    keymap.set('n', '<space>cr', vim.lsp.codelens.refresh, desc('lsp [c]ode lenses [r]efresh'))
    keymap.set('n', 'gr', vim.lsp.buf.references, desc('lsp [g]et [r]eferences'))
    keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, desc('[lsp] [f]ormat buffer'))
    if client.server_capabilities.inlayHintProvider then
      keymap.set('n', '<space>h', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
        vim.lsp.inlay_hint.enable(bufnr, not current_setting)
      end, desc('[lsp] toggle inlay hints'))
    end

    -- Auto-refresh code lenses
    if not client then
      return
    end
    local function buf_refresh_codeLens()
      vim.schedule(function()
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          return
        end
      end)
    end
    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
        group = group,
        callback = buf_refresh_codeLens,
        buffer = bufnr,
      })
      buf_refresh_codeLens()
    end
  end,
})

-- Save Folds in tex files
vim.api.nvim_create_augroup("VimtexBasedWorkflow", { clear = true })
vim.api.nvim_create_autocmd({"BufLeave"}, {
  pattern = {"*.tex"},
  group = "VimtexBasedWorkflow",
  desc = "save view (folds) and append rtp for snippets, when closing file",
  callback = function()
    -- save folds
    vim.cmd("mkview")
    -- remove curbuf dir from rtp
    local buf_dir = vim.fn.expand("%:p:h")
    if buf_dir ~= "" then
      local current_rtp = vim.opt.rtp:get()
      local new_rtp = vim.tbl_filter(function(dir) return dir ~= buf_dir end, current_rtp)
      vim.opt.rtp = new_rtp
    end
  end,

})
vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*.tex"},
  group = "VimtexBasedWorkflow",
  desc = "load view (folds) and append rtp for snippets, when opening file",
  callback = function()
    -- load folds
    vim.cmd("silent! loadview")
    -- add curr buf dir to rtp
    local buf_dir = vim.fn.expand("%:p:h")
    if buf_dir ~= "" then
      vim.opt.rtp:append(buf_dir)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex" },
  group = "VimtexBasedWorkflow",
  callback = function()
    vim.opt_local.conceallevel = 2
    local global_path = vim.g.UltiSnipsSnippetDirectories[1]
    local local_path = vim.loop.cwd() .. "/UltiSnips"
    vim.b.UltiSnipsSnippetDirectories = {global_path, local_path }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"tex", "latex"},
  group = "VimtexBasedWorkflow",
  callback = function()
    vim.keymap.set("i", "<C-f>", function()
      local line = vim.api.nvim_get_current_line()
      local root = vim.b.vimtex.root
      vim.cmd('silent exec ".!inkscapefigures create \\"' .. line .. '\\" \\"' .. root .. '/figures/\\""')
      vim.cmd("w")
    end, { buffer = true, desc = "Create Inkscape figure" })
    vim.keymap.set("n", "<C-f>", function()
      local root = vim.b.vimtex.root
      if root then
        vim.cmd('silent exec "!inkscapefigures edit \\"' .. root .. '/figures/\\" > /dev/null 2>&1 &"')
        vim.cmd("redraw!")
      else
        print("vimtex root not defined")
      end
    end, { buffer = true, desc = "Edit Inkscape figure" })
  end,
})

-- run inkscapefigures watch when opening latex
vim.api.nvim_create_autocmd("BufRead", {
  pattern = {"tex", "latex"},
  group = "VimtexBasedWorkflow",
  callback = function()
    vim.cmd('silent exec ".!inkscapefigures watch"')
  end,
})




-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
-- local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
-- api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
--       vim.opt.relativenumber = true
--     end
--   end,
-- })
-- api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu then
--       vim.opt.relativenumber = false
--       vim.cmd.redraw()
--     end
--   end,
-- })
