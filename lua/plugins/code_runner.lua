-- Compilar e executar arquivos/projetos com um atalho só.
-- <F5> e <F6> abrem o resultado num terminal flutuante (snacks),

-- que permanece aberto depois que o programa termina.
local function run_smart()
  vim.cmd("silent! wall")
  -- Projetos CMake usam o cmake-tools (build + run + debug).
  if vim.fs.root(0, { "CMakeLists.txt", "CMakePresets.json" }) then
    require("lazy").load({ plugins = { "cmake-tools.nvim" } })
    vim.cmd("CMakeRun")
    return
  end
  -- Qualquer outro caso: detecta projeto (Makefile, package.json, ...)
  -- ou simplesmente compila/executa o arquivo atual.
  require("code_runner").run_code()
end

return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    keys = {
      { "<F5>", run_smart, desc = "Compilar/Executar (projeto ou arquivo)" },
      { "<F6>", "<cmd>RunFile<cr>", desc = "Executar o arquivo atual" },
      { "<leader>rr", "<cmd>RunCode<cr>", desc = "Executar (projeto ou arquivo)" },
      { "<leader>rf", "<cmd>RunFile<cr>", desc = "Executar o arquivo atual" },
      { "<leader>rp", "<cmd>RunProject<cr>", desc = "Executar o projeto" },
      { "<leader>rx", "<cmd>RunClose<cr>", desc = "Fechar o runner" },
    },
    opts = {
      mode = "snacks",
      focus = true,
      filetype = {
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt -Wall -Wextra -g && ./$fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt -Wall -Wextra -g && ./$fileNameWithoutExt",
        python = "python3 -u",
        javascript = "node",
        typescript = "deno run",
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        sh = "bash",
        ruby = "ruby",
        rust = "cd $dir && rustc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
      },
    },
  },

  -- Nomes dos grupos no which-key
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>r", group = "Executar" },
        { "<leader>m", group = "CMake" },
      },
    },
  },
}
