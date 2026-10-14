# Neovim IDE (LazyVim)

Configuração pessoal do Neovim baseada no [LazyVim](https://github.com/LazyVim/LazyVim),
voltada para desenvolvimento em geral com foco em **C/C++**, incluindo
**compilar, executar e depurar** direto do editor.

---

## Sumário

1. [Visão geral](#1-visão-geral)
2. [Requisitos](#2-requisitos)
3. [Estrutura de arquivos](#3-estrutura-de-arquivos)
4. [Como funciona](#4-como-funciona)
5. [Extras habilitados](#5-extras-habilitados)
6. [Configurações e plugins próprios](#6-configurações-e-plugins-próprios)
7. [Atalhos](#7-atalhos)
8. [Fluxos de trabalho](#8-fluxos-de-trabalho)
9. [LSP, Mason, formatação e lint](#9-lsp-mason-formatação-e-lint)
10. [Depuração (DAP)](#10-depuração-dap)
11. [Dicas](#11-dicas)
12. [Manutenção](#12-manutenção)
13. [Portabilidade](#13-portabilidade)

---

## 1. Visão geral

Este é um setup do tipo **IDE**, não apenas um editor. Ele oferece:

- **Autocomplete** (blink.cmp), **LSP** (clangd, neocmake, lua_ls, ...) e
  **treesitter** para realce/troca de código.
- **Explorador de arquivos**, **busca** de arquivos/texto (picker do Snacks).
- **Terminal flutuante** e **grep/substituição** integrados.
- **Compilar e executar** qualquer arquivo ou projeto com <kbd>F5</kbd>/<kbd>F6</kbd>.
- **Fluxo CMake** completo (configurar, compilar, executar, depurar) via `cmake-tools`.
- **Debugger** de C/C++ (`codelldb`) via nvim-dap.
- **Git** integrado (gitsigns, lazygit), **sessões**, **which-key** etc.

---

## 2. Requisitos

Instalados via sistema (o resto o próprio Neovim/Esses gerenciadores instalam):

| Ferramenta | Para quê |
|---|---|
| `neovim` (>= 0.10) | o editor |
| `git` | baixar plugins (lazy.nvim) |
| `ripgrep` (`rg`) | busca de texto do picker |
| `fd` | busca de arquivos |
| `unzip` / `curl` | instalação de plugins/ferramentas |
| `gcc`/`g++` (ou `clang`) | compilar C/C++ |
| `cmake` | projetos CMake |
| `node`/`npm` | suporte a JS/TS |
| Fonte **Nerd Font** (ex.: `ttf-jetbrains-mono-nerd`) | ícones da interface |

> Os LSPs e ferramentas (clangd, neocmakelsp, codelldb, stylua, etc.) são
> instalados automaticamente pelo **Mason** — não precisa instalar via sistema.

No Arch:

```bash
sudo pacman -S --needed neovim git ripgrep fd unzip curl gcc make cmake nodejs npm
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

---

## 3. Estrutura de arquivos

```
~/.config/nvim/
├── init.lua                     # ponto de entrada: só chama require("config.lazy")
├── lazyvim.json                 # extras do LazyVim habilitados
├── lazy-lock.json               # versões travadas dos plugins (gerado; ignorado no git)
├── stylua.toml                  # estilo de formatação Lua (2 espaços, 120 colunas)
├── .neoconf.json                # habilitar neodev/lua_ls para os plugins
├── README.md                    # este arquivo
└── lua/
    ├── config/
    │   ├── lazy.lua             # bootstrap + configuração do lazy.nvim
    │   ├── options.lua          # opções do Neovim (vazio: usa o padrão do LazyVim)
    │   ├── autocmds.lua         # autocmds (vazio: usa o padrão do LazyVim)
    │   └── keymaps.lua          # atalhos extras (hoje só aponta para os plugins)
    └── plugins/
        ├── dashboard.lua        # tela inicial (logo ASCII)
        ├── code_runner.lua      # compilar/executar (F5/F6, <leader>r)
        ├── cmake.lua            # fluxo CMake (<leader>m)
        └── example.lua          # exemplo do template (DESATIVADO)
```

---

## 4. Como funciona

### `init.lua`

Só uma linha: `require("config.lazy")`. Todo o resto é carregado por módulos.

### `lua/config/lazy.lua`

Faz o **bootstrap** do [lazy.nvim](https://github.com/folke/lazy.nvim) (baixa
se não existir) e o inicializa:

- importa o LazyVim (`{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`);
- importa seus próprios plugins (`{ import = "plugins" }`), ou seja, tudo em
  `lua/plugins/`;
- `checker.enabled = true`: verifica atualizações periodicamente;
- desativa plugins nativos do Neovim que não usamos (gzip, tar, zip, tutor...).

### `lua/config/options.lua` e `autocmds.lua`

Estão vazios de propósito: usamos os padrões do LazyVim. É aqui que se
adicionariam ajustes de `vim.opt` e `nvim_create_autocmd`.

### `lua/config/keymaps.lua`

Também enxuto. Os atalhos de compilação/execução foram movidos para os
plugins: `code_runner.lua` e `cmake.lua`.

---

## 5. Extras habilitados

Definidos em `lazyvim.json`. Cada "extra" ativa um conjunto de plugins/ajustes:

| Extra | O que adiciona |
|---|---|
| `lang.clangd` | LSP **clangd** para C/C++, treesitter de C++, `clangd_extensions`, e o debugger **codelldb**; atalho `<leader>ch` (alternar header/source) |
| `lang.cmake` | LSP **neocmake**, lint de CMake (`cmakelint`) e o **cmake-tools.nvim** |
| `dap.core` | **Debugger** (nvim-dap + dap-ui + virtual text) e atalhos `<leader>d...` |

---

## 6. Configurações e plugins próprios

### 6.1 `dashboard.lua`

Troca o cabeçalho da tela inicial (`snacks.nvim`) por um **logo ASCII "NADOLNY"**.

### 6.2 `code_runner.lua` — compilar e executar

Plugin **code_runner.nvim**. Define o que fazer ao compilar/executar cada
linguagem e roda o resultado num **terminal flutuante** (Snacks) que **permanece
aberto** após o programa terminar.

- **Modo:** `snacks` (terminal flutuante).
- Comandos por linguagem:

  | Linguagem | Comando |
  |---|---|
  | C | `gcc -Wall -Wextra -g` e executa |
  | C++ | `g++ -Wall -Wextra -g` e executa |
  | Python | `python3 -u` |
  | JavaScript | `node` |
  | TypeScript | `deno run` |
  | Java | `javac` + `java` |
  | Shell | `bash` |
  | Ruby | `ruby` |
  | Rust | `rustc` e executa |

- **Detecção de projeto:** ao executar, procura subindo pelas pastas um
  arquivo-semente (`CMakeLists.txt`, `Makefile`, `package.json`, `Cargo.toml`,
  `go.mod`, `pom.xml`, `.crproject.json`) e roda o comando associado. Se não
  achar, trata como arquivo solto.
- Atalho `<F5>` "inteligente": se for projeto **CMake**, usa o `cmake-tools`
  (ver abaixo); senão, usa o `code_runner`.

Também registra os nomes dos grupos no **which-key** (`<leader>r` = "Executar",
`<leader>m` = "CMake").

### 6.3 `cmake.lua` — fluxo CMake

Configura o **cmake-tools.nvim** e seus atalhos:

- build em `build/`;
- gera `compile_commands.json` (usado pelo clangd para autocomplete do projeto);
- configuração de debug ligada ao `codelldb`;
- atalhos no grupo `<leader>m` (tabela na seção 7.2).

### 6.4 `example.lua` — desativado

Vem do template do LazyVim e começa com `if true then return {} end`, então
**não faz nada**. Está aí só como referência. Pode ser apagado sem efeito.

---

## 7. Atalhos

> `<leader>` é a **barra de espaço**. Ex.: `<leader>ff` = Espaço, depois `f`, `f`.
> Aperte **Espaço** e espere: aparece o menu (which-key) com tudo.

### 7.1 Executar / compilar (custom)

| Atalho | Ação |
|---|---|
| <kbd>F5</kbd> | Compilar/Executar (projeto ou arquivo) |
| <kbd>F6</kbd> | Executar o arquivo atual |
| `<leader>rr` | Executar (projeto ou arquivo) |
| `<leader>rf` | Executar o arquivo atual |
| `<leader>rp` | Executar o projeto |
| `<leader>rx` | Fechar o runner |

### 7.2 CMake (custom)

| Atalho | Ação |
|---|---|
| `<leader>mq` | Iniciar projeto CMake (Quick Start) |
| `<leader>mg` | Gerar/Configurar |
| `<leader>mb` | Compilar |
| `<leader>mr` | Compilar e Executar |
| `<leader>md` | Depurar |
| `<leader>mt` | Selecionar alvo de execução |
| `<leader>mB` | Selecionar alvo de build |
| `<leader>mk` | Selecionar kit (compilador) |
| `<leader>mv` | Selecionar build type |
| `<leader>mc` | Limpar |
| `<leader>ms` | Configurações |
| `<leader>mx` | Parar execução |

### 7.3 Depuração (extra `dap.core`)

| Atalho | Ação |
|---|---|
| `<leader>db` | Alternar breakpoint |
| `<leader>dc` | Iniciar/continuar |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dr` | Abrir REPL |
| `<leader>du` | Abrir/fechar a UI do debugger |
| `<leader>dt` | Encerrar |

### 7.4 Navegação / busca (padrão LazyVim)

| Atalho | Ação |
|---|---|
| `<leader>e` | Explorador de arquivos |
| `<leader>ff` | Procurar arquivos |
| `<leader>fr` | Arquivos recentes |
| `<leader>sg` | Buscar texto (grep) no projeto |
| `<leader>sw` | Buscar a palavra sob o cursor |
| `<leader><space>` | Lista de buffers abertos |
| `<leader>,` | Buffers |
| `<leader>xx` | Diagnósticos (Trouble) |
| `<S-h>` / `<S-l>` | Buffer anterior / próximo |
| `gx` | Abrir link/arquivo no app do sistema |

### 7.5 Código / LSP (padrão LazyVim)

| Atalho | Ação |
|---|---|
| `gd` | Ir para definição |
| `gr` | Ver referências |
| `K` | Documentação do símbolo |
| `<leader>ca` | Ação de código (code action) |
| `<leader>cf` | Formatar arquivo |
| `<leader>ch` | Alternar header/source (C/C++) |
| `<leader>cr` | Renomear símbolo |
| `<leader>gg` | Abrir o lazygit |

---

## 8. Fluxos de trabalho

### 8.1 Exercício de arquivo único (`.c`, `.py`, ...)

1. Abra o arquivo: `nvim caminho/Aula13.c`
2. Escreva o código.
3. <kbd>F6</kbd> → salva, compila e roda no terminal flutuante.
   - Se o programa lê `scanf`/`input`, digite **dentro do terminal** e dê Enter.
4. Feche o terminal (`q`) e repita.

### 8.2 Projeto multi-arquivo com CMake

1. Crie a pasta e abra nela: `nvim MeuProjeto`
2. Crie os fontes (`.c`, `.h`).
3. Crie o `CMakeLists.txt` (atalho `<leader>mq` ou manualmente):

   ```cmake
   cmake_minimum_required(VERSION 3.10)
   project(MeuProjeto C)
   add_executable(meu_programa main.c outro.c)
   ```

4. <kbd>F5</kbd> (ou `<leader>mr`) → configura, compila e executa.
   - Na 1ª vez escolha o **kit** (compilador `gcc`) e a pasta `build/` é criada.
5. Edite → <kbd>F5</kbd> de novo. Use `<leader>mt` para trocar o executável alvo.

---

## 9. LSP, Mason, formatação e lint

- **Mason** (`:Mason`) instala e gerencia LSPs/ferramentas. Já instalados:
  `clangd`, `neocmakelsp`, `lua-language-server`, `cmakelang`, `cmakelint`,
  `stylua`, `shfmt` e `codelldb`.
- **LSP** (nvim-lspconfig) dá autocomplete, diagnósticos, definição, referências.
  Para C/C++, o clangd fica muito mais preciso quando existe `compile_commands.json`
  (gerado pelo cmake-tools ao compilar).
- **Formatação**: `conform.nvim` formata **ao salvar**. Manual: `<leader>cf`.
  Ligar/desligar: `<leader>uf`.
- **Lint**: `nvim-lint` roda linters conforme o tipo de arquivo.
- **Treesitter**: realce e seleção por sintaxe.

---

## 10. Depuração (DAP)

Com o extra `dap.core` e o `codelldb` (C/C++):

1. Abra o arquivo, defina breakpoints com `<leader>db`.
2. `<leader>dc` para iniciar (ou `<leader>md` dentro de um projeto CMake).
3. A UI abre sozinha; use `<leader>di` / `<leader>do` / `<leader>dO` para andar.
4. `<leader>dt` encerra.

> Na primeira depuração o Mason baixa o `codelldb` — aguarde terminar.

---

## 11. Dicas

- **which-key**: aperte <kbd>Espaço</kbd> e espere; ele mostra os atalhos possíveis.
- Descubra o leader atual: `:lua print(vim.g.mapleader or " ")`.
- Comandos de gestão: `:Lazy` (plugins), `:Mason` (ferramentas), `:LazyExtras`
  (ligar/desligar extras), `:checkhealth` (diagnóstico).
- O `lazy-lock.json` **não** é versionado neste repositório (está no
  `.gitignore`), portanto cada máquina pode usar versões diferentes dos plugins.

---

## 12. Manutenção

```vim
:Lazy sync     " instalar/atualizar/limpar plugins
:Lazy update   " atualizar plugins
:Mason         " instalar/atualizar LSPs e ferramentas
:checkhealth   " verificar problemas
```

---

## 13. Portabilidade

Para usar esta config em outra máquina (ex.: Arch):

1. Instale os [requisitos](#2-requisitos).
2. Clone este repositório em `~/.config/nvim`:
   ```bash
   git clone git@github.com:NadolnyJoao/Neovim-configs.git ~/.config/nvim
   ```
3. Abra o `nvim` — o LazyVim instala todos os plugins; o Mason baixa os LSPs.

**Não** copie `~/.local/share/nvim`, `~/.local/state/nvim` nem `~/.cache/nvim`
(são específicos de cada máquina; o Neovim recria do zero).
