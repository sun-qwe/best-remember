# 大脑

- 一句话：一个 git 仓库做跨工具、跨电脑的个人档案，所有 AI 智能体从同一份读背景
- 状态：已推送 GitHub，四个工具入口已接　最后更新：2026-10-26
- 位置：`D:\yupi-ke\git-branch\best-remember`（GitHub: sun-qwe/best-remember）

## 目标

换工具（DSH / buddy / Claude Code / Cursor）、换电脑时不用重新自我介绍；
`me/preferences.md` 里写的偏好，任何工具都遵守。

## 结构决定

- **入口只放路由，不放大段内容。** `AGENTS.md` 控制在 100 行内，全文被读也不会撑爆上下文。
- **分层加载。** 常驻（身份摘要 + 硬约束）vs 按需（项目、决策、日志）。
- **写入只追加。** 智能体写 `inbox.md` / `journal/`，`me/` 由人工蒸馏——否则误解会被反复强化。
- **快慢双通道。** 想法变化先写 `journal/`（下个会话就生效），稳定后才进 `me/`（每周确认）。
- **不覆盖别人的配置。** 入口脚本对已有的 `CLAUDE.md` / `GEMINI.md` 只在末尾追加指针。
- **不用符号链接**，改用"入口文件里写路径"。跨 Windows/macOS、不需要开发者模式或管理员权限。
- **每台机器固定一个路径**，并写进 `me/environment.md`。本机是 `D:\yupi-ke\git-branch\best-remember`，新机器用 `~/brain`。
- **脚本按 PowerShell 5.1 写**，因为这台机器没有 pwsh 7。

## 现在在哪

仓库在 GitHub 上（`sun-qwe/best-remember`），本地已迁到 `D:\yupi-ke\git-branch\best-remember`，两边同步。
`AGENTS.md` 和 `me/` 三个文件已按真实情况填好，环境栏是实测数据。
四个工具入口（Claude Code / Codex / Gemini / Cursor）已写入；DSH 靠工作区 `AGENTS.md` 零配置生效。

踩过的两次坑：`.git` 在桌面上被清掉一次（历史丢失，已重建）；目录搬过三次
（`大脑` → `桌面2\best-remember` → `yupi-ke\git-branch\best-remember`），每次都忘了要重跑 `link.ps1`。

## 下一步

- [x] 填 `AGENTS.md` 身份 + `me/` 三个文件（环境栏为实测数据）
- [x] 接上本机四个工具入口（`scripts/link.ps1`）
- [x] 建 private repo 并推送（`sun-qwe/best-remember`）
- [x] 迁出桌面，换到 `D:\yupi-ke\git-branch\best-remember`
- [ ] 在新目录开 DSH 会话，验证「我的称呼是什么」→ 孙少
- [ ] 第二台机器 clone + link，验证跨机器真的通
- [ ] 挂登录任务自动 pull（命令见 `scripts/sync.ps1` 注释）
- [ ] 每周跑一次 `scripts/distill-prompt.md` 里那段话，至少连续两周

## 坑

- 写太多 → 上下文被吃掉，智能体反而不听话。`AGENTS.md` 控制在 100 行内。
- 入口没接对 → 表现为"它根本没读"。验证方法：开新会话问「我这台机器 Python 装在哪」。
- `.ps1` 无 BOM 会被 5.1 当 GBK 解码，中文语法报错。见 `me/environment.md`。
- **搬目录后忘跑 `link.ps1`** → 工具读到死链，静默失效。
- **别把仓库放桌面** → 清理工具会动它，`.git` 丢过一次。
- 只在 DSH 里好用不算成功——它本来就是零配置。真正的验证点是 Claude Code 或 buddy。
