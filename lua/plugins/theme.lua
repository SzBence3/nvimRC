return {
    {
        "askfiy/visual_studio_code",
        priority = 1000,
        lazy = false,
        -- config = function()
        --     vim.cmd([[colorscheme visual_studio_code]])
        -- end,
    },
    --tokyonight
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
            -- setting the comment color to gray
            vim.api.nvim_set_hl(0, "Comment", { fg = "#63677d", italic = false })
            --setting the copilot suggestion color to gray
            vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#808080" })
        end,
    },
}
