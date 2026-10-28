# Instalação no Windows (Neovim + Neovide)

Esse repo foi feito pra rodar igualzinho no Linux, mas funciona no **Windows** com poucos ajustes. A ideia é **clonar direto na pasta certa do Neovim** — simples e fácil de exportar/replicar.

> Foco primário: **C/C++**. O resto funciona igual ao Linux, mas o `F5`/`F6` usa shell Unix-style (`gcc/g++`, `./exe`) — no Windows isso funciona se você usar um terminal compatível (MSYS2/MinGW, Git Bash) ou ajustar o `code_runner`. Veja abaixo.

## 1) Instalar dependências

Você precisa de:

| Ferramenta | Sugestão | Notas |
|---|---|---|
| [Neovim](https://github.com/neovim/neovim/releases) | `winget install Neovim.Neovim` ou baixar direto | Versão >= 0.10 |
| [Neovide](https://neovide.dev/) (opcional, GUI) | `winget install neovide.neovide` ou baixar binário | Ótimo no Windows, mas o `nvim` no terminal também funciona |
| [Git](https://git-scm.com/) | `winget install Git.Git` | Precisa pra clonar e pros plugins |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `winget install BurntSushi.ripgrep.MSVC` | Busca |
| [fd](https://github.com/sharkdp/fd) | `winget install sharkdp.fd` | Busca de arquivos |
| [CMake](https://cmake.org/) | `winget install Kitware.CMake` | Para projetos CMake |
| Compilador C/C++ | **MinGW-w64** ou **LLVM/Clang** | Sugestão: MSYS2 + `mingw-w64-x86_64-gcc` ou `llvm` |

**Com winget (rápido):**

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd Kitware.CMake neovide.neovide
```

**MSYS2 para toolchain (recomendado pra C/C++):**

1. Instale [MSYS2](https://www.msys2.org/)
2. Abra `MSYS2 UCRT64` (ou MINGW64) e instale:

```bash
pacman -S --needed mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gdb mingw-w64-ucrt-x86_64-make
```

3. Adicione `C:\msys64\ucrt64\bin` (ou `mingw64\bin`) ao **PATH** do Windows.

## 2) Clonar a configuração

No Windows, o Neovim procura a config em `%LOCALAPPDATA%\nvim\`.

Abra um terminal (PowerShell, CMD ou Windows Terminal) e rode:

```powershell
git clone git@github.com:NadolnyJoao/Neovim-configs.git "$env:LOCALAPPDATA\nvim"
```

Se você preferir HTTPS (sem configurar SSH keys):

```powershell
git clone https://github.com/NadolnyJoao/Neovim-configs.git "$env:LOCALAPPDATA\nvim"
```

> Assim como no Linux: **não** copie `lazy-lock.json` entre máquinas. Ele fica no `.gitignore` mesmo.

## 3) Primeira execução

1. Abra o Neovim: `nvim` no terminal **ou** `neovide` (GUI).
2. O `lazy.nvim` vai fazer o bootstrap e baixar os plugins automaticamente.
3. O `:Mason` vai instalar `clangd`, `codelldb`, etc. na primeira vez.
4. Pronto. O mesmo setup que você tem no Linux vai carregar.

## 4) Dicas pro Windows

- **Usando Neovide:** você pode criar um atalho pro `neovide.exe` apontando pra qualquer pasta. Ele respeita exatamente a config em `%LOCALAPPDATA%\nvim`.
- **Terminal pra compilar:** se o `F5` não achar `gcc/g++`, garanta que seu compilador está no PATH. Se usar MSYS2, rode o Neovim pelo terminal do MSYS2 ou tenha o `bin` no PATH global.
- **CMake:** o fluxo `<leader>m` funciona normal. Na primeira vez o `cmake-tools` vai te pedir o **kit** (escolha seu compilador MinGW/Clang).
- **Path separators:** o config já usa APIs do Neovim (`vim.fs.*`) — não precisa mexer em quase nada. O `code_runner` usa comandos shell Unix-style; pra maioria dos casos com MSYS/Git Bash funciona. Se quiser, você pode editar `lua/plugins/code_runner.lua` pra usar `.exe` explicitamente.
- **Omarchy theme:** ignorado no Windows (arquivo não existe) — cai no tema padrão sem problemas.

## 5) Atualizar / manter

```powershell
cd "$env:LOCALAPPDATA\nvim"
git pull
```

Dentro do Neovim: `:Lazy sync`, `:Mason`, `:checkhealth`.

---

**Dica prática:** pra "exportar" pro Windows é só clonar esse repo na pasta certa. Simples assim.
