local langs = { "c", "cpp", "lua", "python", "rust", "asm", "make", "cmake",
 "linkerscript", "tsx", "jsdoc", "html", "css", "scss", "json", "graphql", 
 "javascript", "typescript", "systemverilog", "vhdl", "bash","tcl", "perl", 
 "toml", "xml", "yaml", "ini", "sql", "dockerfile", "markdown", "markdown_inline",
 "vim", "vimdoc", "query", "luadoc", "regex", "diff", "git_config", "gitcommit",
 "gitignore", "comment", }

require("nvim-treesitter").install(langs)

vim.treesitter.language.register("systemverilog", {"verilog", "systemverilog"})
vim.treesitter.language.register("javascript", "javascriptreat")
vim.treesitter.language.register("tsx", "typescriptreact")

vim.api.nvim_create_autocmd("FileType", {
  pattern = langs,
  callback = function() pcall(vim.treesitter.start) end,
})
