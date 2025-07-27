return {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
        { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
        vim.lsp.enable('pyright')
        vim.lsp.enable('rust_analyzer')
    end
}
