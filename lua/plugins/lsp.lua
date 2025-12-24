return {
    "mason-org/mason-lspconfig.nvim",
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        local servers = {}
        local opts = {
            ensure_installed = { "sqlls","clangd", "lua_ls", "pyright", "ts_ls", "cmake", "rust_analyzer", "html", "cssls", "jsonls", "bashls", "yamlls"},
            automatic_installation = true,
            -- automatic_enable = true,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }
        require('mason-lspconfig').setup(opts)


        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),

            callback = function(event)
                -- for debugging (mostly)
                -- print('Lsp attached')
                -- small macro for keybindings
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gR', vim.lsp.buf.rename, '[R]e[N]ame')
                map('ga', vim.lsp.buf.code_action, 'code [A]ction')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                local builtin = require("telescope.builtin")
                map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                map('gi', builtin.lsp_implementations, '[G]oto [I]mplemtation')
                map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                map('gs', builtin.lsp_document_symbols, 'Open Document Symbols')
                map('gws', builtin.lsp_dynamic_workspace_symbols, 'Open [W]orkspace Symbols')
                map('gt', builtin.lsp_type_definitions, '[G]oto [T]ype')
                -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                ---@param client vim.lsp.Client
                ---@param method vim.lsp.protocol.Method
                ---@param bufnr? integer some lsp support methods only in specific files
                ---@return boolean
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has 'nvim-0.11' == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end
                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end

                if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    vim.lsp.inlay_hint.enable(true)
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, '[T]oggle Inlay [H]ints')
                end
            end
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            } or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        }
    end,
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "saghen/blink.cmp",
            version = '1.*',
            opts = {
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                    providers = {
                        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                    },
                },
                keymap = {
                    preset = 'default',
                    ["<Up>"] = false,
                    ["<Down>"] = false,
                    ["<C-z>"] = { "accept" },
                },
                completion = {
                    -- By default, you may press `<c-space>` to show the documentation.
                    -- Optionally, set `auto_show = true` to show the documentation after a delay.
                    documentation = { auto_show = true, auto_show_delay_ms = 500 },
                },
                signature = { enabled = true },
            }
        },
        -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim',    opts = {} },
    }
}
