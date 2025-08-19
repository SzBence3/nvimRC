return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    opts = {
        ensure_installed = { 'c', 'c++', 'lua', 'javascript', 'markdown'},
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_high_lighting = false,
        }
    },
}
