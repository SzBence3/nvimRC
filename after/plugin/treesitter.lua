require("nvim-treesitter.configs").setup({
    ensure_installed = {"cpp", "c", "lua", "javascript", "markdown", "cmake"},
    auto_install=true,
    sync_install = false,
    highlight = {
        enable =true,
        additional_vim_regexp_highlighting = false,
    },
})
