return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- build = "make install_jsregexp"  -- install jsregexp (optional!).
    config = function()
        require('luasnip.loaders.from_snipmate').lazy_load()
    end,
}
