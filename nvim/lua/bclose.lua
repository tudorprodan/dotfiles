-- Delete a buffer while keeping the window/split layout intact.
-- (Plain :bd will close the window when there are splits — this won't.)
--
-- Load it from init.lua with:   require('bclose').setup()
-- Gives you:  <leader>bd   and   :Bd / :Bd!

local M = {}

local function buf_delete_keep_window(force)
    local cur = vim.api.nvim_get_current_buf()

    if not force and vim.bo[cur].modified then
        vim.notify('Unsaved changes — use Bd! to force', vim.log.levels.WARN)
        return
    end

    local function usable(b)
        return b ~= cur and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end

    -- prefer the alternate buffer (#), otherwise the first other listed buffer
    local target
    local alt = vim.fn.bufnr('#')
    if usable(alt) then
        target = alt
    else
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if usable(b) then
                target = b
                break
            end
        end
    end

    -- redirect every window showing `cur` to the replacement (make one if needed)
    local replacement = target
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == cur then
            if not replacement then
                replacement = vim.api.nvim_create_buf(true, false) -- empty scratch so window survives
            end
            vim.api.nvim_win_set_buf(win, replacement)
        end
    end

    if vim.api.nvim_buf_is_valid(cur) then
        vim.api.nvim_buf_delete(cur, { force = force or false })
    end
end

function M.setup()
    vim.api.nvim_create_user_command('Bd', function(o)
        buf_delete_keep_window(o.bang)
    end, { bang = true, desc = 'Delete buffer, keep window/splits' })

    vim.keymap.set('n', '<leader>bd', function()
        buf_delete_keep_window()
    end, { desc = 'Delete buffer, keep window/splits' })

    vim.keymap.set('n', '<leader>bD', function()
        buf_delete_keep_window(true)
    end, { desc = 'Delete buffer, keep window/splits' })
end

return M
