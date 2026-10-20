-- Faz o nvim seguir o tema atual do Omarchy.
-- O Omarchy gera ~/.local/state/omarchy/current/theme/neovim.lua com as
-- cores do tema ativo (ex.: Ristretto -> aether.nvim). Trocar de tema com
-- "omarchy theme set" e reabrir o nvim já aplica o novo visual.
-- Fora do Omarchy (máquina sem esse arquivo), fica o tema default do LazyVim.
local theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(theme) == 1 then
  return dofile(theme)
end
return {}
