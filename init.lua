vim.opt.background = "dark"
vim.opt.autochdir = true
vim.opt.swapfile = false
-- How fast (in ms) to trigger background tasks: diagnostics, saving to swap, etc.
vim.opt.updatetime = 250

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.spell = false
vim.opt.cursorline = true
vim.opt.showmatch = true

vim.opt.winborder = "rounded"
vim.opt.mouse = "a"
vim.opt.switchbuf = "vsplit"

vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "~", extends = ">", precedes = "<" }

-- Sync clipboard between OS & nvim.
vim.opt.clipboard = "unnamedplus"
-- Show completion menu even with 1 match, do not auto-insert, do not auto-select 1st item.
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.wildmenu = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.smartindent = true

-- Colorscheme.
vim.pack.add({"https://github.com/mellow-theme/mellow.nvim"}, { confirm = false })
vim.cmd.colorscheme("mellow")

-- Filebrowser & fuzzy-finder.
vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-file-browser.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
}, { confirm = false })
local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'
local actions = require "telescope.actions"
telescope.setup{
  extensions = {
    file_browser = {
      disable_devicons = true,
      mappings = {
        i = {
          ["<C-t>"] = actions.select_tab
        },
      },
    },
  }
}
telescope.load_extension "file_browser"

vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser)
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)

-- LSP & completion plugins.
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/dcampos/nvim-snippy",
    "https://github.com/dcampos/cmp-snippy",

}, { confirm = false })

local cmp = require "cmp"
local snippy = require "snippy"
cmp.setup({
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    },
    ['<C-e>'] = cmp.mapping(
      function(fallback)
        snippy.expand_or_advance(fallback)
      end
    ),
  }),
  sources = {
    {name = "latex_symbols"},
    {name = "nvim_lsp"},
    {name = "snippy"},
    {name = "buffer"},
    {name = "path"},
  },
})

-- Git plugin.
vim.pack.add({"https://github.com/lewis6991/gitsigns.nvim"}, { confirm = false })
require 'gitsigns'.setup()

-- LaTeX symbols completion plugin.
vim.pack.add({"https://github.com/kdheepak/cmp-latex-symbols"}, { confirm = false })

-- Show indentation lines.
vim.pack.add({"https://github.com/lukas-reineke/indent-blankline.nvim"}, { confirm = false })
require "ibl".setup()

-- Clear search highlights with Esc.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Remove trailing spaces with F4.
vim.keymap.set("n", "<F4>", "<cmd>:%s/\\s\\+$//e<CR>")

-- Bind keys for LSP.
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<F2>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<F3>', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

-- Enable LSP servers.
vim.lsp.enable("pyright")
