# Neovim IDE — foco em C/C++ (LazyVim)

Configuração pessoal do Neovim baseada no [LazyVim](https://github.com/LazyVim/LazyVim),
**voltada primariamente para desenvolvimento em C/C++**: compilar, executar e
depurar direto do editor, com suporte completo a projetos **CMake**.

> **Outras linguagens:** o LazyVim de base continua editando qualquer linguagem
> (realce, autocomplete e LSP instalado sob demanda ao abrir o arquivo), mas as
> ferramentas **customizadas deste repo** — atalhos <kbd>F5</kbd>/<kbd>F6</kbd>,
> fluxo CMake e debugger — são específicas de C/C++. Para usar o setup em outra
> linguagem (Java, Python, Go...) é preciso **configuração adicional**: habilitar
> o extra correspondente em `lazyvim.json` (ex.: `lang.java`) e/ou adicionar
> plugins próprios em `lua/plugins/`.

---

## Sumário

1. [Requisitos](#1-requisitos)
2. [Instalação (clone)](#2-instalação-clone)
3. [Windows](#3-windows)
4. [Estrutura de arquivos](#4-estrutura-de-arquivos)
5. [O que está configurado](#5-o-que-está-configurado)
6. [Atalhos](#6-atalhos)
7. [Fluxos de trabalho](#7-fluxos-de-trabalho)
8. [LSP, Mason, formatação e lint](#8-lsp-mason-formatação-e-lint)
9. [Depuração (DAP)](#9-depuração-dap)
10. [Dicas e manutenção](#10-dicas-e-manutenção)

---

## 1. Requisitos

Instalados via sistema (o resto o Neovim/Mason instalam sozinhos):

| Ferramenta | Para quê |
|---|---|
| `neovim` (>= 0.10) | o editor |
| `git` | baixar plugins (lazy.nvim) |
| `ripgrep` (`rg`) | busca de texto do picker |
| `fd` | busca de arquivos |
| `unzip` / `curl` | instalação de plugins/ferramentas |
| `gcc`/`g++` (ou `clang`) | compilar C/C++ |
| `cmake` | projetos CMake |
| Fonte **Nerd Font** (ex.: `ttf-jetbrains-mono-nerd`) | ícones da interface |

> LSPs e ferramentas (clangd, neocmakelsp, codelldb, stylua...) são instalados
> automaticamente pelo **Mason** — não precisa instalar via sistema.

No Arch:

```bash
sudo pacman -S --needed neovim git ripgrep fd unzip curl gcc make cmake
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

## 2. Instalação (clone)

**Linux / macOS:**

```bash
git clone git@github.com:NadolnyJoao/Neovim-configs.git ~/.config/nvim
```

**Windows:** veja [WINDOWS.md](WINDOWS.md) — clone em `%LOCALAPPDATA%\nvim` (também funciona com [Neovide](https://neovide.dev/)).

Depois abra o `nvim`: o lazy.nvim faz o bootstrap, baixa todos os plugins e o
Mason instala os LSPs/ferramentas. Pronto.

- **Não** copie `~/.local/share/nvim`, `~/.local/state/nvim` nem `~/.cache/nvim`
  entre máquinas — são específicas de cada uma; o Neovim recria do zero.
- O `lazy-lock.json` **não** é versionado (está no `.gitignore`), então cada
  máquina usa/congela suas próprias versões de plugins sem conflito de merge.

## 3. Windows

Guia prático em [WINDOWS.md](WINDOWS.md): instalar Neovim/Neovide, clonar em `%LOCALAPPDATA%\nvim`, toolchain MinGW/LLVM + CMake/ripgrep/fd e primeira execução.

---

## 4. Estrutura de arquivos

```
~/.config/nvim/
├── init.lua                     # entrypoint: rooter + require("config.lazy")
├── lazyvim.json                 # extras do LazyVim habilitados
├── lazy-lock.json               # versões travadas dos plugins (gerado; ignorado no git)
├── stylua.toml                  # estilo de formatação Lua
├── .neoconf.json                # lua_ls/neodev para desenvolver o config
├── README.md                    # este arquivo
└── lua/
    ├── config/
    │   ├── rooter.lua           # cd automático pra raiz do projeto ao abrir arquivo
    │   ├── lazy.lua             # bootstrap do lazy.nvim
    │   ├── options.lua          # opções (padrão do LazyVim)
    │   ├── autocmds.lua         # autocmds (padrão do LazyVim)
    │   └── keymaps.lua          # só aponta pros plugins
    └── plugins/
        ├── dashboard.lua        # tela inicial com cabeçalho SORTEADO (artes ASCII)
        ├── omarchy-theme.lua    # nvim segue o tema do Omarchy (no-op fora dele)
        ├── code_runner.lua      # compilar/executar (F5/F6, <leader>r)
        ├── cmake.lua            # fluxo CMake (<leader>m)
        └── example.lua          # template do LazyVim (DESATIVADO, pode apagar)
```

---

## 5. O que está configurado

### Extras (`lazyvim.json`)

| Extra | O que adiciona |
|---|---|
| `lang.clangd` | LSP **clangd** (C/C++), treesitter de C++, `clangd_extensions`, debugger **codelldb**, `<leader>ch` (header/source) |
| `lang.cmake` | LSP **neocmake**, lint de CMake, **cmake-tools.nvim** |
| `dap.core` | **Debugger** (nvim-dap + dap-ui + virtual text) e atalhos `<leader>d...` |

### Plugins próprios

- **`rooter.lua`** — ao abrir um arquivo, o cwd salta pra raiz do projeto
  (detecta `.git`, `CMakeLists.txt`, `Makefile`, `package.json`). Sem isso,
  nvim aberto em outra pasta faria o `<F5>`/CMake/picker operarem no diretório
  errado.
- **`omarchy-theme.lua`** — carrega o tema gerado pelo Omarchy
  (`~/.local/state/omarchy/current/theme/neovim.lua`); trocar de tema no sistema
  e reabrir o nvim já aplica o novo visual.
- **`dashboard.lua`** — tela inicial com cabeçalho **sorteado a cada abertura**
  de uma lista de artes ASCII. Para editar as frases, mexa só na lista
  `headers` no topo do arquivo.
- **`code_runner.lua`** — compila/executa com um tecla só. Salva todos os
  buffers antes de rodar (nunca compila arquivo desatualizado). Roda num
  terminal flutuante (Snacks) que permanece aberto. Comandos:

  | Linguagem | Comando |
  |---|---|
  | C | `gcc -Wall -Wextra -g` + executa |
  | C++ | `g++ -Wall -Wextra -g` + executa |
  | Python / JS / TS / Java / Shell / Ruby / Rust | comandos padrões |

  Detecção de projeto: sobe pastas procurando `CMakeLists.txt`, `Makefile`,
  `package.json`, `Cargo.toml`, `go.mod`, `pom.xml` ou `.crproject.json` e roda
  o comando associado; senão, compila o arquivo atual.
- **`cmake.lua`** — cmake-tools com build em `build/`, geração de
  `compile_commands.json` (clangd enxerga o projeto inteiro), debug via
  `codelldb` e o grupo de atalhos `<leader>m`.

---

## 6. Atalhos

> `<leader>` é a **barra de espaço**. Aperte <kbd>Espaço</kbd> e espere: o
> which-key mostra tudo.

### Executar / compilar (custom)

| Atalho | Ação |
|---|---|
| <kbd>F5</kbd> | Compilar/Executar (projeto ou arquivo; salva antes) |
| <kbd>F6</kbd> | Executar o arquivo atual (salva antes) |
| `<leader>rr` | Executar (projeto ou arquivo) |
| `<leader>rf` | Executar o arquivo atual |
| `<leader>rp` | Executar o projeto |
| `<leader>rx` | Fechar o runner |

### CMake (custom)

| Atalho | Ação |
|---|---|
| `<leader>mq` | Iniciar projeto CMake (Quick Start) |
| `<leader>mg` | Gerar/Configurar |
| `<leader>mb` | Compilar |
| `<leader>mr` | Compilar e Executar |
| `<leader>md` | Depurar |
| `<leader>mt` / `<leader>mB` | Selecionar alvo de execução / de build |
| `<leader>mk` / `<leader>mv` | Selecionar kit (compilador) / build type |
| `<leader>mc` / `<leader>mx` | Limpar / Parar execução |

### Depuração (extra `dap.core`)

| Atalho | Ação |
|---|---|
| `<leader>db` | Alternar breakpoint |
| `<leader>dc` | Iniciar/continuar |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step into / out / over |
| `<leader>du` | Abrir/fechar a UI do debugger |
| `<leader>dt` | Encerrar |

### Navegação / busca (padrão LazyVim)

| Atalho | Ação |
|---|---|
| `<leader>e` | Explorador de arquivos |
| `<leader>ff` / `<leader>fr` | Procurar arquivos / recentes |
| `<leader>sg` / `<leader>sw` | Buscar texto (grep) / palavra sob o cursor |
| `<leader>xx` | Diagnósticos (Trouble) |
| `<leader>gg` | lazygit |
| `<S-h>` / `<S-l>` | Buffer anterior / próximo |

### Código / LSP (padrão LazyVim)

| Atalho | Ação |
|---|---|
| `gd` / `gr` | Definição / referências |
| `K` | Documentação do símbolo |
| `<leader>ca` / `<leader>cr` | Ação de código / renomear |
| `<leader>cf` | Formatar arquivo |
| `<leader>ch` | Alternar header/source (C/C++) |

---

## 7. Fluxos de trabalho

### Arquivo único (`.c`)

1. Abra o arquivo de qualquer pasta (o rooter ajusta o cwd sozinho).
2. <kbd>F6</kbd> → salva, compila e roda no terminal flutuante.
3. Se o programa pedir input, digite **dentro do terminal** e dê Enter.

### Projeto CMake

1. Abra o nvim dentro (ou abra qualquer arquivo de lá):
   `nvim ~/PROJETOS/MeuProjeto/main.c`
2. Crie o `CMakeLists.txt` (manual ou `<leader>mq`):

   ```cmake
   cmake_minimum_required(VERSION 3.16)
   project(MeuProjeto LANGUAGES C)
   add_executable(meu_programa main.c outro.c)
   target_include_directories(meu_programa PRIVATE .)
   ```

3. <kbd>F5</kbd> (ou `<leader>mr`) → configura, compila e executa.
   - Na 1ª vez escolha o **kit** (`gcc`); a pasta `build/` é criada.
4. Edite → <kbd>F5</kbd> de novo. `<leader>mt` troca o alvo; `<leader>md` depura.

---

## 8. LSP, Mason, formatação e lint

- **Mason** (`:Mason`) gerencia LSPs/ferramentas. Já instalados neste setup:
  `clangd`, `neocmakelsp`, `lua-language-server`, `cmakelang`, `cmakelint`,
  `stylua`, `shfmt` e `codelldb`.
- Para C/C++, o clangd fica muito mais preciso com o `compile_commands.json`
  gerado pelo cmake-tools ao compilar.
- **Formatação** (`conform.nvim`) roda ao salvar; manual: `<leader>cf`;
  liga/desliga: `<leader>uf`.
- **Treesitter** dá realce/seleção por sintaxe.

## 9. Depuração (DAP)

1. `<leader>db` para pôr breakpoint.
2. `<leader>dc` para iniciar (ou `<leader>md` num projeto CMake).
3. Ande com `<leader>di` / `<leader>do` / `<leader>dO`; `<leader>dt` encerra.

> Na primeira depuração o Mason baixa o `codelldb` — aguarde.

---

## 10. Dicas e manutenção

- <kbd>Espaço</kbd> + espera → which-key lista os atalhos.
- `:Lazy` (plugins), `:Mason` (ferramentas), `:LazyExtras` (extras),
  `:checkhealth` (diagnóstico), `:LazyRoot` (root atual do buffer).
- Manutenção: `:Lazy sync` (instalar/atualizar/limpar), `:Lazy update`,
  `:checkhealth`.

---

Feito com C, CMake e teimosia.
