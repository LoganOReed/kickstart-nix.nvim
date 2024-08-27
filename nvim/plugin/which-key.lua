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
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

keymap("n", "<leader>ss", "<cmd>UltiSnipsEdit<cr>", opts)
keymap("n", "<leader>sr", "<cmd>call UltiSnips#RefreshSnippets()<cr>", opts)

-- Current version has a bug with floating window. TEMP:
--keymap("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open parent directory" })

wk.register({
    { "<C-h>", "<C-w>h", desc = "Window left" },
    { "<C-j>", "<C-w>j", desc = "Window down" },
    { "<C-k>", "<C-w>k", desc = "Window up" },
    { "<C-l>", "<C-w>l", desc = "Window right" },
    { "<Esc>", ":noh <CR>", desc = "Clear highlights" },
    { "<leader>f", group = "Find" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffer" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "List Todos" },
    { "<leader>l", group = "Lsp" },
    { "<leader>p", group = "Project" },
    { "<leader>pp", ":Telescope projects<CR>", desc = "Find Projects" },
    { "<leader>t", group = "Term" },
    { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Dont copy replaced text" },
  })
