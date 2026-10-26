# 大脑 · 跨工具、跨电脑的个人档案

一个 git 仓库，装「我是谁、我怎么想、我在做什么、之前为什么这么定」。
Claude Code、Codex、Cursor、Gemini CLI 这些工具都从这一份读背景——换工具、换电脑都不用重新自我介绍。

## 先纠正一个前提

**记忆不会自动互通。** 每个工具把自己的记忆存在自己的格式和位置里，互相看不见，也没有标准。
但它们几乎都认同一件事：**项目里或用户目录下的 Markdown 指令文件**（`AGENTS.md` / `CLAUDE.md` / `GEMINI.md` / `.cursor/rules`）。

所以做法不是「同步记忆」，而是：

> 把记忆放成一个 git 仓库 → 让每个工具的开场指令都指向它。

这件事没有自动生效的魔法。每个工具第一次跟你说话时就必须被告诉"去读这个"，
这就是 `AGENTS.md` 和 `scripts/link.ps1` 的用途。**没接入口的文件等于不存在。**

## 三步开始

只想最快用起来，做完第 1、2 步就够，其余文件用到再填。

1. **填三个文件**
   - `AGENTS.md` — 我是谁（4 行）+ 硬约束 + 路由表
   - `me/identity.md` — 背景、长期目标、不擅长什么
   - `me/preferences.md` — 回答风格、语言、禁忌（**性价比最高的一份**）
2. **接上工具** — `powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1`
   会先把已有配置备份到 `~/.brain-backup-<时间>/`，再写入指向本仓库的入口。
   （脚本按 Windows PowerShell 5.1 写，本机没有 pwsh 7 也能跑。）
3. **推到 GitHub**（私有仓库！）见下。

## GitHub 侧

```powershell
# 先在 GitHub 上建一个 private 仓库，假设叫 brain（不要勾选自动生成 README）
git remote add origin git@github.com:<你的用户名>/brain.git
git push -u origin main
```

新电脑（Windows）：

```powershell
git clone git@github.com:<你的用户名>/brain.git "$env:USERPROFILE\brain"
cd "$env:USERPROFILE\brain"
powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1
```

macOS / Linux：

```bash
git clone git@github.com:<你的用户名>/brain.git ~/brain
cd ~/brain && bash scripts/link.sh
```

**路径约定：所有机器统一放 `~/brain`。** 一台放桌面、一台放 D 盘，每个工具的入口配置都得跟着改，
而且文档里写的路径全是错的。仓库里的脚本都用"脚本自己的位置"定位根目录，所以放哪都能跑，
但你的手和文档会感谢你统一。

## 每天怎么用

| 时机 | 动作 |
|---|---|
| 开工 | `powershell -ExecutionPolicy Bypass -File .\scripts\sync.ps1 -Pull`，或者挂到登录任务里自动跑 |
| 干活 | 正常提问。智能体按 `AGENTS.md` 的路由自己去读需要的文件 |
| 收工 | 说一句「收个尾」。它往 `journal/<机器名>.md` 追加 ≤3 行，新事实进 `inbox.md` |
| 每周 10 分钟 | 开一个会话：「读 inbox 和最近的 journal，提议合并进 me/ 和 projects/」——你逐条点头或删 |

**最后一行是关键。** 只增不减的档案，三周后就没人读、也没人信了。这叫蒸馏，只能人做。

## 接到别的东西上

- **DSH**：零配置。它会把当前工作区的 `AGENTS.md` 自动当指令注入——在这个目录里开工就生效了。
  这份档案本身就是这么建的。
- **别的代码仓库**：在那边仓库根目录建一个 `AGENTS.md`，内容就一行：
  `开工前先读 <本仓库绝对路径>/AGENTS.md，按它的路由和写入协议工作。`
  偏好只有一份，不要复制粘贴到每个项目里——那样改一处要改十处。
- **网页版 / 手机 App**（ChatGPT、Claude 网页版等）：它们读不到你本地文件。用 [`digest.md`](digest.md)
  里那一屏摘要，整段粘进自定义指令 / Project 说明，或者每次贴一段。
- **换一个新工具，三步**：
  1. 直接问那个工具：「你支持从哪个文件读取全局指令？给我准确路径」——多数工具知道自己
  2. 在那个文件里只写一行指针（指向本仓库 `AGENTS.md`），**不要复制内容**
  3. 验证：开新会话问「我是谁、我不熟哪些领域？」——能答出那六项就通了
  4. 读不到文件、只支持设置框的，退回 `digest.md` 粘贴
- **接了 MCP 的工具**：可以上 `basic-memory`、`mem0` 这类记忆服务，能自动读写。但每个工具都要配一遍 MCP，
  配置成本比一个 Markdown 文件高。个人用户先跑 Markdown + git，不够用了再说。

## 几条硬规矩

- **仓库必须 private。** 里面有你的经历、客户、决策理由。
- **绝不提交密钥**：API key、密码、token、`.env`、私钥。要存就存系统钥匙串，只在 `me/environment.md` 里写"在哪"。
- **同一时间只在一台机器写。** 两台同时改必然冲突。开工 pull，收工 push。
- **智能体只能追加，不能直接改 `me/`。** 否则它的误解会被自己反复强化，你会得到一份自信的错档案。
- **不记会过期的东西**：今天哪个 bug 没修、临时路径、一次性的命令。
  **记会复用的**：偏好、决策理由、踩过的坑、为什么放弃了另一个方案。

## 目录

| 路径 | 作用 | 谁写 |
|---|---|---|
| `AGENTS.md` | 唯一入口：身份摘要 + 硬约束 + 路由表 | 你 |
| `me/identity.md` | 我是谁、背景、长期目标、不擅长什么 | 你 |
| `me/preferences.md` | 语言、结构、禁忌、代码与决策偏好 | 你（从 inbox 蒸馏） |
| `me/environment.md` | 机器、路径、工具链、常用命令 | 你 |
| `projects/` | 每个在推进的项目一页 | 你 |
| `people.md` | 身边的人、称呼、沟通偏好 | 你 |
| `decisions/` | 决策记录：定了什么、为什么、放弃了什么 | 你 |
| `journal/` | 每台机器一个文件，追加式日志（原料） | 智能体 |
| `inbox.md` | 待确认的新事实 | 智能体 |
| `scripts/` | 接工具、同步的小脚本 | — |

## 恢复

`scripts/link.ps1` 每次写入前都会备份到 `~/.brain-backup-<时间>/`。
想撤掉某个工具的入口，把备份里的文件拷回去，或直接删掉入口文件。
本仓库不碰系统级配置、不装软件、不建计划任务（登录任务那条命令在脚本注释里，想挂你自己挂）。
