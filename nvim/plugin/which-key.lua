if vim.g.did_load_which_key_plugin then
  return
end
vim.g.did_load_which_key_plugin = true

local wk = require("which-key")

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap.set
local diagnostic = vim.diagnostic

-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- Fix Paste with Clipboard
keymap("x", "p", "P")

-- better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase window width" })



-- Current version has a bug with floating window. TEMP:
keymap("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
keymap("n", "<leader>E", "<cmd>Oil<cr>", { desc = "Open parent directory without float" })


wk.add(  {
    { "<Esc>", ":noh <CR>", desc = "Clear highlights" },
    { "<leader>f", group = "Find" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffer" },
    { "<leader>fe", "<cmd>Telescope nerdy<cr>", desc = "Find NerdFont Emoji" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "List Todos" },
    { "<leader>fn", "<cmd>Telescope manix<cr>", desc = "List Nix Docs" },
    { "<leader>fN", "<cmd>lua require('telescope-manix').search({cword = true})<cr>", desc = "List Nix Doc Under Cursor" },
    { "<leader>l", group = "Lsp" },
    { "<leader>p", group = "Project" },
    { "<leader>pp", ":Telescope projects<CR>", desc = "Find Projects" },
    { "<leader>s", group = "Snippets" },
    { "<leader>sl", "<cmd>call UltiSnips#ListSnippets()<cr>", desc = "List Relevant Snippets" },
    { "<leader>sr", "<cmd>call UltiSnips#RefreshSnippets()<cr>", desc = "Refresh UltiSnips Snippets" },
    { "<leader>ss", "<cmd>UltiSnipsEdit<cr>", desc = "Edit UltiSnips" },
    { "<leader>t", group = "Term" },
    { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Dont copy replaced text" },
  })

-- wk.register({
--   ["<Esc>"] = { ":noh <CR>", "Clear highlights" },
--   ["<leader>l"] = { name = "+Lsp" },
--
--   ["<leader>p"] = { name = "+Project" },
--   ["<leader>pp"] = { ":Telescope projects<CR>", "Find Projects" },
--
--   ["<leader>f"] = { name = "+Find" },
--   ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
--   ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
--   ["<leader>fe"] = { "<cmd>Telescope nerdy<cr>", "Find NerdFont Emoji" },
--   ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--   ["<leader>fl"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
--   ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "List Todos" },
--
--   ["<leader>s"] = { name = "+Snippets" },
--   ["<leader>ss"] = { "<cmd>UltiSnipsEdit<cr>", "Edit UltiSnips" },
--   ["<leader>sl"] = { "<cmd>call UltiSnips#ListSnippets()<cr>", "List Relevant Snippets" },
--   ["<leader>sr"] = { "<cmd>call UltiSnips#RefreshSnippets()<cr>", "Refresh UltiSnips Snippets" },
--
--   ["<leader>t"] = { name = "+Term" },
--
--   -- switch between windows
--   -- ["<C-h>"] = { "<C-w>h", "Window left" },
--   -- ["<C-l>"] = { "<C-w>l", "Window right" },
--   -- ["<C-j>"] = { "<C-w>j", "Window down" },
--   -- ["<C-k>"] = { "<C-w>k", "Window up" },
--
--   ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
-- })
