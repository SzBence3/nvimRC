return {
    "nvim-telescope/telescope.nvim",
    tag='0.1.8',
    dependencies={
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        'olimorris/persisted.nvim',
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        require("telescope").setup{
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown()
                }
            }
        }
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
        pcall(require('telescope').load_extension, 'persisted')

        local builtin = require("telescope.builtin")

        vim.keymap.set('n','<leader>ff',builtin.find_files, { desc = "[F]ind [F]iles" })
        vim.keymap.set('n','<leader>fw',builtin.git_files, { desc = "[F]ind in git files" })
        vim.keymap.set('n','<leader>fh',builtin.help_tags, { desc = "[F]ind [H]elp" })
        vim.keymap.set('n','<leader>fg',builtin.live_grep, { desc = "Live [G]rep" })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc ='[F]ind current [W]ord' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
        vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<C-f>', builtin.current_buffer_fuzzy_find, { desc = 'Find in this buffer' })
        vim.keymap.set('n', '<leader>fq', builtin.quickfix, {desc = "[F]ind in [Q]uickfix list"})

        -- finding in conf files
        vim.keymap.set('n', '<leader>fn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[F]ind [N]eovim files' })


    end

}
