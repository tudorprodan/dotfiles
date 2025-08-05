local opt = vim.opt

opt.termguicolors = true

opt.splitright = true
opt.splitbelow = true

opt.tabstop = 4
opt.shiftwidth = 4
vim.bo.softtabstop = 4
opt.expandtab = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.iskeyword:append("-")

opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds

vim.opt.list = true
vim.opt.listchars = {
  tab = '>.',
  trail = '.',
  extends = '#',
  nbsp = '.'
}
vim.opt.showbreak = '↪'

vim.opt.completeopt = 'menu,menuone,noinsert,noselect'
opt.wildmode = 'longest:full'

vim.diagnostic.config({
    virtual_text = true,
    -- virtual_lines = { current_line = true },
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded" }, -- add border to diagnostic popups
})

