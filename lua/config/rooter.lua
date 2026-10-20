-- rooter.lua — ao abrir um arquivo, o cwd salta para a raiz do projeto.
-- Sem isso, nvim aberto em outra pasta faz o <F5>, o CMake e os pickers
-- operarem no diretório errado (cwd continua sendo onde o nvim foi aberto).

local group = vim.api.nvim_create_augroup("user_rooter", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  desc = "cwd automático para a raiz do projeto do buffer",
  callback = function(ev)
    -- só buffers de arquivos reais (ignora terminais, prompts, dashboard...)
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == "" then
      return
    end
    local root = vim.fs.root(ev.buf, { ".git", "CMakeLists.txt", "Makefile", "package.json" })
    if root and root ~= vim.fn.getcwd() then
      vim.cmd.cd(root)
    end
  end,
})
