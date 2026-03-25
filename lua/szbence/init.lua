
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})


require("szbence.settings")
require("szbence.keymap")
require("szbence.autocmds")
require("config.lazy")

