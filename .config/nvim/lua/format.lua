local cmd = vim.cmd

cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
]])

cmd([[
let g:neoformat_enabled_go = ['gofumpt', 'gofmt']
let g:neoformat_enabled_typescript = ['prettierd', 'prettier', 'prettier-eslint', 'tslint', 'tsfmt']
]])
