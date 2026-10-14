-- Fluxo de trabalho CMake estilo IDE (configure, build, run, debug, targets).
return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_use_preset = true,
      cmake_regenerate_on_save = true,
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_directory = "build",
      -- Gera/atualiza compile_commands.json para o clangd (autocomplete do projeto).
      cmake_compile_commands_options = { action = "soft_link", target = vim.uv.cwd },
      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
    },
    keys = {
      { "<leader>mq", "<cmd>CMakeQuickStart<cr>", desc = "CMake: Iniciar projeto (Quick Start)" },
      { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "CMake: Gerar/Configurar" },
      { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "CMake: Compilar" },
      { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "CMake: Compilar e Executar" },
      { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "CMake: Depurar" },
      { "<leader>mt", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake: Selecionar alvo de execução" },
      { "<leader>mB", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake: Selecionar alvo de build" },
      { "<leader>mk", "<cmd>CMakeSelectKit<cr>", desc = "CMake: Selecionar kit (compilador)" },
      { "<leader>mv", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake: Selecionar build type" },
      { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "CMake: Limpar" },
      { "<leader>ms", "<cmd>CMakeSettings<cr>", desc = "CMake: Configurações" },
      { "<leader>mx", "<cmd>CMakeStopRunner<cr>", desc = "CMake: Parar execução" },
    },
  },
}
