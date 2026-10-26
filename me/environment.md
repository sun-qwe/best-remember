# 环境

> 以下是**实际跑命令确认过**的，不是猜的。版本或路径变了就改这里。

## 系统

- Windows 11（NT 10.0.26200）
- Shell：**Windows PowerShell 5.1**（默认的 `powershell.exe`）。这台机器**没有** pwsh 7
- 没有 bash（`scripts/link.sh` 只能在 macOS/Linux 上验证）

## 工具链（实测路径）

| 工具 | 版本 | 路径 / 备注 |
|---|---|---|
| git | 2.51.0.windows.1 | `D:\hongmeng\Sdk\Git\cmd\git.exe`（**非标准路径**，别假设在 Program Files） |
| node | v24.9.0 | `C:\nvm4w\nodejs\node.exe`（nvm4w 管理） |
| npm | 11.6.0 | `C:\nvm4w\nodejs\npm.ps1` |
| pnpm | 未安装 | — |
| python | 3.11.3 | `D:\pycharm\python\python.exe` |
| uv | 0.11.16 | `D:\pycharm\python\Scripts\uv.exe` |
| VS Code | 1.139.1 | `D:\vscode\bin\code.cmd` |

## AI 工具现状

| 工具 | 状态 | 备注 |
|---|---|---|
| DSH | **在用** | 会把当前工作区的 `AGENTS.md` 自动作为指令注入 → 本仓库放对位置就零配置生效 |
| buddy | **在用** | 同样接 DeepSeek 的 key；它认不认 `AGENTS.md` 还没验证 |
| Claude Code | 已装 2.1.270 | `C:\nvm4w\nodejs\claude.ps1`，入口配 `~/.claude/CLAUDE.md` |
| Codex | 有配置目录 `~/.codex`（46 项） | CLI 不在 PATH，实际怎么启动待确认 |
| Gemini CLI | 有配置 `~/.gemini/GEMINI.md` | CLI 不在 PATH |
| Cursor | 已装（`~/.cursor`） | 入口配 `~/.cursor/rules/brain.mdc` |

> 两个主力（DSH、buddy）都走 DeepSeek 的 key。所以这套档案的价值不在"接更多工具"，
> 而在于「换工具、换电脑，背景还在」。

## 机器约定

- 仓库位置：本机 `D:\桌面2\大脑`；**其它机器统一放 `~/brain`**
- 路径含中文，个别 CLI 会出问题，必要时加引号
- 没有 `gh` CLI → GitHub 操作用 `git` 命令或网页
- 未开开发者模式 → 建符号链接要管理员，所以入口用「写文件」不用软链

## 踩过的坑

- **`.ps1` 必须存成 UTF-8 带 BOM**：5.1 遇到无 BOM 的 UTF-8 会按 GBK 解码，中文直接语法报错
  （`The string is missing the terminator`）。只影响 `.ps1`，`.md` / `.sh` 用无 BOM。
- `D:\桌面2\大脑` 曾缺 `WRITE_OWNER` 权限，导致所有命令报
  `SetNamedSecurityInfoW failed (Win32 5)`。修复记录在 `D:\桌面2\acl-recovery\`。
  以后遇到同样报错，先查文件权限，不是代码问题。
- git 在 Windows 上对 LF/CRLF 有警告，本仓库用 `.gitattributes` 统一，忽略那些 warning 即可。

## 账号与凭据（只写"在哪"，不写值）

- GitHub：<你的用户名>，SSH key 在 `~/.ssh/`（是否已配待确认）
- git 全局提交身份已配置（`user.name = sun`）
- **密钥一律不进本仓库**，`.gitignore` 已挡 `.env` / `*.key` / `secrets/`
