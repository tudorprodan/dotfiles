-- return {
--   "navarasu/onedark.nvim",
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     require('onedark').setup {
--       style = 'warmer'
--     }
--     -- Enable theme
--     require('onedark').load()
--   end
-- }

return {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.sonokai_style = 'shusia'
        vim.g.sonokai_better_performance = 1
        -- vim.g.sonokai_transparent_background = 1
        vim.g.sonokai_colors_override = { bg0 = {"#1B1D1E", 0} }
        vim.cmd [[colorscheme sonokai]]
    end
}

-- return {
--     "tanvirtin/monokai.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         -- require('monokai').setup {}
--         require('monokai').setup { palette = require('monokai').pro }
--         -- require('monokai').setup { palette = require('monokai').soda }
--         -- require('monokai').setup { palette = require('monokai').ristretto }
--         -- require('monokai').setup({ italics = false })
--     end
-- }

-- -- Molokai old
-- vim.g.rehash256 = 1
-- vim.cmd [[colorscheme molokai_match_fix]]
-- return {}
