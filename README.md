# Neovim IDE — C/C++ com LazyVim

Configuração pessoal do Neovim baseada no [LazyVim](https://github.com/LazyVim/LazyVim), com foco em desenvolvimento em **C e C++**. O setup permite compilar, executar e depurar programas direto do editor e inclui suporte a projetos **CMake**.

> O LazyVim também pode ser usado com outras linguagens, com recursos como realce de sintaxe, autocomplete e LSP. Os atalhos F5/F6, o fluxo CMake e as configurações de depuração deste repositório são voltados a C/C++. Para trabalhar com outras linguagens, habilite o extra correspondente em `lazyvim.json` — como `lang.java` — e, se necessário, adicione plugins em `lua/plugins/`.

## Sumário

1. [Requisitos](#1-requisitos)
2. [Instalação](#2-instalação)
3. [Windows](#3-windows)
4. [Estrutura de arquivos](#4-estrutura-de-arquivos)
5. [Configurações](#5-configurações)
6. [Atalhos](#6-atalhos)
7. [Fluxos de trabalho](#7-fluxos-de-trabalho)
8. [LSP, Mason, formatação e lint](#8-lsp-mason-formatação-e-lint)
9. [Depuração](#9-depuração-dap)
10. [Dicas e manutenção](#10-dicas-e-manutenção)

## 1. Requisitos

Instale pelo sistema as ferramentas abaixo. O restante dos plugins e ferramentas é gerenciado pelo Neovim e pelo Mason.

|Ferramenta|Uso|
|---|---|
|`neovim` (>= 0.10)|Editor|
|`git`|Baixar plugins pelo lazy.nvim|
|`ripgrep` (`rg`)|Busca de texto|
|`fd`|Busca de arquivos|
|`unzip` e `curl`|Instalação de plugins e ferramentas|
|`gcc`/`g++` ou `clang`|Compilação de C/C++|
|`cmake`|Projetos CMake|
|Fonte Nerd Font, como `ttf-jetbrains-mono-nerd`|Ícones da interface|

O Mason instala ferramentas como `clangd`, `neocmakelsp` e `codelldb`.

No Arch Linux:

```
sudo pacman -S --needed neovim git ripgrep fd unzip curl gcc make cmake
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

## 2. Instalação

### Linux e macOS

```
git clone git@github.com:NadolnyJoao/Neovim-configs.git ~/.config/nvim
```

### Windows

Consulte o [WINDOWS.md](WINDOWS.md). O repositório deve ser clonado em `%LOCALAPPDATA%\nvim`. Essa configuração também pode ser usada com o [Neovide](https://neovide.dev/).

Depois de clonar, abra o Neovim. O lazy.nvim será iniciado, baixará os plugins e o Mason instalará as ferramentas configuradas.

- Não copie `~/.local/share/nvim`, `~/.local/state/nvim` ou `~/.cache/nvim` entre máquinas. Esses diretórios contêm dados locais que o Neovim recria.
- O arquivo `lazy-lock.json` não é versionado e está no `.gitignore`. Assim, cada máquina mantém suas próprias versões dos plugins.

## 3. Windows

O guia [WINDOWS.md](WINDOWS.md) explica como instalar o Neovim ou Neovide, clonar a configuração em `%LOCALAPPDATA%\nvim` e preparar as ferramentas necessárias, como MinGW ou LLVM, CMake, ripgrep e fd.

## 4. Estrutura de arquivos

```
~/.config/nvim/
├── init.lua                     # Inicialização do rooter e do lazy.nvim
├── lazyvim.json                 # Extras do LazyVim habilitados
├── lazy-lock.json               # Versões dos plugins; gerado e ignorado pelo Git
├── stylua.toml                  # Formatação de arquivos Lua
├── .neoconf.json                # Configuração de lua_ls/neodev para editar este setup
├── README.md                    # Este arquivo
└── lua/
    ├── config/
    │   ├── rooter.lua           # Ajusta o diretório raiz do projeto
    │   ├── lazy.lua             # Inicializa o lazy.nvim
    │   ├── options.lua          # Opções do Neovim
    │   ├── autocmds.lua         # Autocomandos
    │   └── keymaps.lua          # Referências aos atalhos dos plugins
    └── plugins/
        ├── dashboard.lua        # Tela inicial com arte ASCII aleatória
        ├── omarchy-theme.lua    # Integração com o tema do Omarchy
        ├── code_runner.lua      # Compilação e execução com F5/F6 e <leader>r
        ├── cmake.lua            # Atalhos e fluxo para projetos CMake
        └── example.lua          # Exemplo do LazyVim, desativado
```

## 5. Configurações

### Extras do LazyVim

|Extra|Recursos|
|---|---|
|`lang.clangd`|LSP clangd, Treesitter para C/C++, `clangd_extensions`, debugger codelldb e atalho `<leader>ch` para alternar entre header e source|
|`lang.cmake`|LSP neocmakelsp, lint para CMake e `cmake-tools.nvim`|
|`dap.core`|Debugger com nvim-dap, dap-ui, virtual text e atalhos `<leader>d...`|

### Plugins deste repositório

- **`rooter.lua`** — ao abrir um arquivo, define o diretório de trabalho como a raiz do projeto. Procura por `.git`, `CMakeLists.txt`, `Makefile` e `package.json`. Isso permite que os atalhos de execução, o CMake e os pickers usem o diretório correto.
    
- **`omarchy-theme.lua`** — carrega o tema do Omarchy em `~/.local/state/omarchy/current/theme/neovim.lua`. Ao trocar o tema do sistema e reabrir o Neovim, o novo visual é aplicado.
    
- **`dashboard.lua`** — mostra uma arte ASCII escolhida aleatoriamente a cada abertura. Para editar as opções, altere a lista `headers` no início do arquivo.
    
- **`code_runner.lua`** — salva os buffers antes de compilar ou executar e abre o resultado em um terminal flutuante do Snacks, que permanece aberto. Oferece comandos para C, C++, Python, JavaScript, TypeScript, Java, Shell, Ruby e Rust. Para C e C++, usa `gcc -Wall -Wextra -g` ou `g++ -Wall -Wextra -g`.
    
    O runner procura arquivos de projeto como `CMakeLists.txt`, `Makefile`, `package.json`, `Cargo.toml`, `go.mod`, `pom.xml` e `.crproject.json`. Se não encontrar um projeto compatível, compila ou executa o arquivo atual.
    
- **`cmake.lua`** — configura o `cmake-tools.nvim` para usar a pasta `build/`, gerar `compile_commands.json` para o clangd e depurar com codelldb. Os atalhos ficam agrupados em `<leader>m`.
    

## 6. Atalhos

O `<leader>` é a barra de espaço. Pressione Espaço e aguarde para ver os atalhos disponíveis no which-key.

### Executar e compilar

|Atalho|Ação|
|---|---|
|`F5`|Compila e executa o projeto ou arquivo atual, depois de salvar|
|`F6`|Executa o arquivo atual, depois de salvar|
|`<leader>rr`|Executa o projeto ou arquivo atual|
|`<leader>rf`|Executa o arquivo atual|
|`<leader>rp`|Executa o projeto|
|`<leader>rx`|Fecha o runner|

### CMake

|Atalho|Ação|
|---|---|
|`<leader>mq`|Inicia um projeto CMake com Quick Start|
|`<leader>mg`|Gera ou configura o projeto|
|`<leader>mb`|Compila|
|`<leader>mr`|Compila e executa|
|`<leader>md`|Inicia a depuração|
|`<leader>mt` / `<leader>mB`|Seleciona o alvo de execução / de compilação|
|`<leader>mk` / `<leader>mv`|Seleciona o kit / tipo de build|
|`<leader>mc` / `<leader>mx`|Limpa / interrompe a execução|

### Depuração

|Atalho|Ação|
|---|---|
|`<leader>db`|Alterna um breakpoint|
|`<leader>dc`|Inicia ou continua a execução|
|`<leader>di` / `<leader>do` / `<leader>dO`|Step into / step out / step over|
|`<leader>du`|Abre ou fecha a interface do debugger|
|`<leader>dt`|Encerra a depuração|

### Navegação e busca

|Atalho|Ação|
|---|---|
|`<leader>e`|Abre o explorador de arquivos|
|`<leader>ff` / `<leader>fr`|Busca arquivos / arquivos recentes|
|`<leader>sg` / `<leader>sw`|Busca texto / palavra sob o cursor|
|`<leader>xx`|Abre os diagnósticos do Trouble|
|`<leader>gg`|Abre o lazygit|
|`<S-h>` / `<S-l>`|Vai para o buffer anterior / próximo|

### Código e LSP

|Atalho|Ação|
|---|---|
|`gd` / `gr`|Vai para a definição / mostra referências|
|`K`|Mostra a documentação do símbolo|
|`<leader>ca` / `<leader>cr`|Ação de código / renomeação|
|`<leader>cf`|Formata o arquivo|
|`<leader>ch`|Alterna entre header e source em C/C++|

## 7. Fluxos de trabalho

### Arquivo C ou C++ isolado

1. Abra o arquivo. O rooter ajusta o diretório de trabalho automaticamente.
2. Pressione `F6` para salvar, compilar e executar.
3. Se o programa solicitar uma entrada, digite-a no terminal flutuante e pressione Enter.

### Projeto CMake

1. Abra o Neovim dentro do projeto ou passe o caminho de um arquivo:
    
    ```
    nvim ~/PROJETOS/MeuProjeto/main.c
    ```
    
2. Crie um `CMakeLists.txt` manualmente ou use `<leader>mq`. Exemplo:
    
    ```
    cmake_minimum_required(VERSION 3.16)
    project(MeuProjeto LANGUAGES C)
    
    add_executable(meu_programa main.c outro.c)
    target_include_directories(meu_programa PRIVATE .)
    ```
    
3. Pressione `F5` ou `<leader>mr` para configurar, compilar e executar o projeto.
    
4. Na primeira execução, selecione o kit do compilador, como `gcc`. O CMake criará a pasta `build/`.
    
5. Para executar novamente depois de editar, pressione `F5`. Use `<leader>mt` para trocar o alvo e `<leader>md` para iniciar a depuração.
    

## 8. LSP, Mason, formatação e lint

- Abra `:Mason` para gerenciar LSPs e outras ferramentas.
- Este setup inclui `clangd`, `neocmakelsp`, `lua-language-server`, `cmakelang`, `cmakelint`, `stylua`, `shfmt` e `codelldb`.
- Em projetos C/C++, o clangd usa o `compile_commands.json` gerado pelo cmake-tools para analisar melhor o projeto.
- O `conform.nvim` formata os arquivos ao salvar. Use `<leader>cf` para formatar manualmente e `<leader>uf` para ativar ou desativar a formatação.
- O Treesitter fornece realce de sintaxe e recursos de seleção de código.

## 9. Depuração (DAP)

1. Pressione `<leader>db` para adicionar um breakpoint.
2. Pressione `<leader>dc` para iniciar a depuração. Em projetos CMake, também é possível usar `<leader>md`.
3. Use `<leader>di`, `<leader>do` e `<leader>dO` para percorrer o código.
4. Pressione `<leader>dt` para encerrar a sessão.

Na primeira depuração, o Mason pode precisar baixar o `codelldb`.

## 10. Dicas e manutenção

- Pressione Espaço e aguarde para consultar os atalhos no which-key.
- Use `:Lazy` para gerenciar plugins, `:Mason` para ferramentas, `:LazyExtras` para extras, `:checkhealth` para diagnósticos e `:LazyRoot` para consultar a raiz atual.
- Para instalar, atualizar ou remover plugins, use `:Lazy sync`. Para atualizar os plugins, use `:Lazy update`.

---

Feito com C, CMake e teimosia.