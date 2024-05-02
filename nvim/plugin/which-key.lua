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

keymap("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })

wk.register({
  ["<Esc>"] = { ":noh <CR>", "Clear highlights" },
  ["<leader>l"] = { name = "+Lsp" },

  ["<leader>p"] = { name = "+Project" },
  ["<leader>pp"] = { ":Telescope projects<CR>", "Find Projects" },

  ["<leader>f"] = { name = "+Find" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
  ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
  ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  ["<leader>fl"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
  ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "List Todos" },

  ["<leader>t"] = { name = "+Term" },

  -- switch between windows
  ["<C-h>"] = { "<C-w>h", "Window left" },
  ["<C-l>"] = { "<C-w>l", "Window right" },
  ["<C-j>"] = { "<C-w>j", "Window down" },
  ["<C-k>"] = { "<C-w>k", "Window up" },

  ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
})
