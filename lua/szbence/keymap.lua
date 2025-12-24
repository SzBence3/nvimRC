vim.g.maplocalleader = " "
vim.g.mapleader = " "

vim.keymap.set('n', '<Leader>e', ":Ex<CR>", {})
vim.keymap.set('n', 'Q', '')

vim.keymap.set('n', '<leader>s', function()
    vim.lsp.buf.format()
end, { desc = 'Format file' })

vim.keymap.set('n', '<Esc>', "<cmd>nohlsearch<CR>")

vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<M-j>', "V:m '>+1<CR>==")
vim.keymap.set('n', '<M-k>', "V:m '<-2<CR>==")

local function feedkeys(keys)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        "n", -- mode: "n" = normal input, "i" = insert, "v" = visual,
        true -- escape CSI (recommended)
    )
end

local function surroundWith(s)
    return function()
        local mode = vim.fn.visualmode()
        if mode == 'v' then
            feedkeys("di" .. s .. "<Esc>hplvi" .. string.sub(s, 1, 1))
        elseif mode == 'V' then
            feedkeys("dkA " .. s .. "<Left><CR><Esc>==kp1V=gv")
        else -- sdfszevasz sdf
            feedkeys("I" .. string.sub(s, 1, 1) .. "<Esc>gvA" .. string.sub(s, 2, 2) .. "<Esc>gv")
        end  -- sadfszevasz asdf
    end
end

vim.keymap.set('v', 'g(', surroundWith('()'), { desc = "Surround with ()" })
vim.keymap.set('v', 'g[', surroundWith('[]'), { desc = "Surround with []" })
vim.keymap.set('v', 'g{', surroundWith('{}'), { desc = "Surround with {}" })
vim.keymap.set('v', 'g\'', surroundWith('\'\''), { desc = "Surround with ''" })
vim.keymap.set('v', 'g"', surroundWith('""'), { desc = "Surround with \"\"" })

vim.keymap.set('n', 'z(', 'zfa(', { desc = 'Fold inside ()' })
vim.keymap.set('n', 'z[', 'zfa[', { desc = 'Fold inside []' })
vim.keymap.set('n', 'z{', 'zfa{', { desc = 'Fold inside {}' })
vim.keymap.set('n', 'z"', 'zfa"', { desc = 'Fold inside ""' })
vim.keymap.set('n', 'z\'', 'zfa\'', { desc = 'Fold inside \'\'' })
vim.keymap.set('n', 'zt', 'zfat', { desc = 'Fold inside tag' })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- doesnt work
-- vim.keymap.set('n', 'z#', '[#lV%zf', {desc = 'Fold inside #'})

vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank to system clipboard' })

vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Pasting from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Pasting from system clipboard' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Pasting from system clipboard' })

vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Deleting to void' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Deleting to void' })

vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' })

local function is_cursor_between_brackets()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.') -- 1-based index
    if col <= 1 or col > #line then
        return false
    end
    local before = line:sub(col - 1, col - 1)
    local after = line:sub(col, col)
    local pairs = { ["("] = ")", ["["] = "]", ["{"] = "}" }
    return pairs[before] == after
end

vim.keymap.set('i', '<CR>',function()
    if is_cursor_between_brackets() then
        return '<CR><Esc>O'
    else
        return '<CR>'
    end
end , { expr = true, desc = 'Auto indent on Enter' })

-- NOTE: Harpoon config

vim.keymap.set('n', '<leader>ha', function() require("harpoon.mark").add_file() end, { desc = "Mark File (Harpoon)" })

vim.g.copilot_no_tab_map = true

-- CodeCompanion keymaps
vim.keymap.set('n', '<leader>ct', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat' })

vim.keymap.set('n', '<leader>ci', ':CodeCompanionChat #{buffer} ', { desc = 'Open inline CodeCompanion' })

vim.keymap.set('n', '<leader>ck', ':CodeCompanionCmd ', { desc = 'Open cmd CodeCompanion' })
vim.keymap.set('v', '<leader>ck', ':CodeCompanionCmd ', { desc = 'Open cmd CodeCompanion' })



