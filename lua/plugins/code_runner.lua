-- Compilar e executar arquivos/projetos com um atalho só.
-- <F5> e <F6> abrem o resultado num terminal flutuante (snacks),
-- que permanece aberto depois que o programa termina.

-- Salva todos os buffers antes de executar, para não compilar um
-- arquivo desatualizado (evita erros como "undefined reference to main").
local function save_all()
  vim.cmd("silent! wall")
end

local function run_smart()
  save_all()
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

local function run_file()
  save_all()
  require("code_runner").run_filetype()
end

local function run_code()
  save_all()
  require("code_runner").run_code()
end

local function run_project()
  save_all()
  require("code_runner").run_project()
end

return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    keys = {
      { "<F5>", run_smart, desc = "Compilar/Executar (projeto ou arquivo)" },
      { "<F6>", run_file, desc = "Executar o arquivo atual" },
      { "<leader>rr", run_code, desc = "Executar (projeto ou arquivo)" },
      { "<leader>rf", run_file, desc = "Executar o arquivo atual" },
      { "<leader>rp", run_project, desc = "Executar o projeto" },
      { "<leader>rx", "<cmd>RunClose<cr>", desc = "Fechar o runner" },
    },
    opts = {
      mode = "snacks",
      focus = true,
      -- Também salva quando os comandos :RunFile/:RunCode forem usados direto.
      before_run_filetype = save_all,
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
