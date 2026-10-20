-- Dashboard (snacks.nvim): o cabeçalho é SORTEADO a cada abertura do nvim.
-- Para editar as frases, mexa só na lista "headers" abaixo.
local headers = {
  [[
 ███╗   ██╗ █████╗ ██████╗  ██████╗ ██╗     ███╗   ██╗██╗   ██╗
 ████╗  ██║██╔══██╗██╔══██╗██╔═══██╗██║     ████╗  ██║╚██╗ ██╔╝
 ██╔██╗ ██║███████║██║  ██║██║   ██║██║    ██╔██╗ ██║ ╚████╔╝
 ██║╚██╗██║██╔══██║██║  ██║██║   ██║██║    ██║╚██╗██║  ╚██╔╝
 ██║ ╚████║██║  ██║██████╔╝╚██████╔╝███████╗██║ ╚████║   ██║
 ╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝
  ]],
  [[
  sem commit, nao existe
  ]],
  [[
  gambiarra e feature em estado de graça
  ]],
  [[
  ctrl+z da vida real nao existe
  ]],
  [[
  um dia eu termino o SHIT
  ]],
}

-- Semente diferente a cada abertura (senao o LuaJIT sorteia sempre igual)
math.randomseed(vim.uv.hrtime() % 2147483647)

return {
  {
    "folke/snacks.nvim",
    opts = function()
      return {
        dashboard = {
          preset = {
            header = headers[math.random(#headers)],
          },
        },
      }
    end,
  },
}
