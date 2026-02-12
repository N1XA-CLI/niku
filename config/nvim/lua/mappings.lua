require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>co", "<cmd> VimtexCompile <cr>")
map("n", "<leader>cv", "<cmd> VimtexView <cr>")
map("n", "<leader>cq", "<cmd> VimtexStop <cr>")

map("v", "<leader>dd", "<Plug>SlimeRegionSend")
map("n", "<leader>dd", "<Plug>SlimeParagraphSend")
map("n", "<leader>dc", "<cmd> SlimeConfig <cr>")

map("n", "<leader>a", "<cmd>AerialToggle!<CR>")
map("n", "<leader>cu", "<cmd> ShowkeysToggle <cr>")

local opts = { noremap = true, silent = true }

-- Normal mode movement remaps (jikl)
map("n", "j", "h", opts) -- j moves left
map("n", "k", "j", opts) -- i moves down
map("n", "i", "k", opts) -- k stays up
map("n", "l", "l", opts) -- l stays right

-- Visual mode movement remaps
map("v", "j", "h", opts)
map("v", "i", "j", opts)
map("v", "k", "k", opts)
map("v", "l", "l", opts)

-- Only disable the *original* keys you're not reusing
map("n", "h", "<Nop>", opts)
-- Remap ; to insert mode (since i is now down)
map("n", "[", "i", { noremap = true, silent = true, desc = "Insert mode (was i)" })
vim.keymap.set("i", ";;", "<Esc>", { noremap = true, silent = true })
