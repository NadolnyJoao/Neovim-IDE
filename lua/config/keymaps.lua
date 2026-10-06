-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Compilar e rodar projeto CMake em um Terminal Flutuante com <F5>
-- Compilar e rodar projeto CMake no Terminal Flutuante correto com <F5>
-- Compilar e rodar projeto CMake no Terminal Flutuante segurando a tela com <F5>
vim.keymap.set("n", "<F5>", function()
  -- Salva todos os arquivos antes de compilar
  vim.cmd("wall")

  -- O truque está no final: adicionamos um comando que espera você dar Enter
  local cmd =
    "clear && cmake --build build && ./build/trabalho_testes; echo -e '\\n[Processo encerrado. Pressione Enter para fechar]'; read"

  -- Abre usando o terminal flutuante do Snacks
  Snacks.terminal(cmd, { cwd = vim.uv.cwd() })
end, { desc = "CMake: Rodar no Terminal Flutuante (Snacks)" })
