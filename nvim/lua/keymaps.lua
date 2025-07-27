local keymap = vim.keymap

keymap.set('n', '<leader>w', ':w<CR>')

keymap.set('v', '<leader>y', '"+y')
keymap.set('n', '<leader>p', '"+p')
keymap.set('v', '<leader>p', '"+p')
keymap.set('n', '<leader>P', '"+P')
keymap.set('v', '<leader>P', '"+P')

keymap.set('n', '<C-p>', ':bp<CR>')
keymap.set('n', '<C-n>', ':bn<CR>')

keymap.set('n', '<leader>c', '<Plug>Commentary')
keymap.set('v', '<leader>c', '<Plug>Commentary')

keymap.set('n', '<C-h>', '<C-w>h')
keymap.set('n', '<C-j>', '<C-w>j')
keymap.set('n', '<C-k>', '<C-w>k')
keymap.set('n', '<C-l>', '<C-w>l')

keymap.set('n', '<CR>', ':noh<CR><CR>')
keymap.set('i', '<C-c>', '<Esc>')
