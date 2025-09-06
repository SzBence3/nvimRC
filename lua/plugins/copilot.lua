return {
    {
        'zbirenbaum/copilot.lua',
        -- event = 'VeryLazy',
        cmd = "Copilot", -- load when you run :Copilot
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    layout = {
                        position = 'right',
                    }
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                },
            })
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        opts = {
            strategys = {
                chat = {
                    name = 'antrophic',
                    model = 'antrophic',
                },
                inline = {
                    name = 'antrophic',
                    model = 'antrophic',
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
