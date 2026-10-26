# 大脑

- 一句话：一个 git 仓库做跨工具、跨电脑的个人档案，所有 AI 智能体从同一份读背景
- 状态：骨架已建成并填入真实内容，待推送 GitHub　最后更新：2026-02-13
- 位置：`D:\桌面2\大脑`（目标：GitHub private repo）

## 目标

换工具（DSH / buddy / Claude Code / Cursor）、换电脑时不用重新自我介绍；
`me/preferences.md` 里写的偏好，任何工具都遵守。

## 结构决定

- **入口只放路由，不放大段内容。** `AGENTS.md` 控制在 100 行内，全文被读也不会撑爆上下文。
- **分层加载。** 常驻（身份摘要 + 硬约束）vs 按需（项目、决策、日志）。
- **写入只追加。** 智能体写 `inbox.md` / `journal/`，`me/` 由人工蒸馏——否则误解会被反复强化。
- **不覆盖别人的配置。** 入口脚本对已有的 `CLAUDE.md` / `GEMINI.md` 只在末尾追加指针。
- **不用符号链接**，改用"入口文件里写路径"。跨 Windows/macOS、不需要开发者模式或管理员权限。
- **所有机器统一 `~/brain`**，避免文档里的路径每台机器都不一样。
- **脚本按 PowerShell 5.1 写**，因为这台机器没有 pwsh 7。

## 现在在哪

骨架 18 个文件已建成并提交（`main`）。`AGENTS.md`、`me/identity.md`、`me/preferences.md`、
`me/environment.md` 已按真实情况填好，环境那一栏是跑命令实测的。
DSH 侧已经零配置生效（它自动注入工作区 `AGENTS.md`）。还没推 GitHub，
其它工具（Claude Code / Cursor / Codex / Gemini）的入口还没接。

## 下一步

- [x] 填 `AGENTS.md` 身份 + `me/identity.md` + `me/preferences.md` + `me/environment.md`
- [ ] 跑 `powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1` 接上本机其它工具
- [ ] 建 private repo，`git remote add` + `push`
- [ ] 第二台机器 clone + link，验证跨机器真的通
- [ ] 挂登录任务自动 pull（命令见 `scripts/sync.ps1` 注释）
- [ ] 定一个每周蒸馏的时间，并真的执行两周

## 坑

- 写太多 → 上下文被吃掉，智能体反而不听话。先控制在 200 行以内。
- 入口没接对 → 表现为"它根本没读"。验证方法：开新会话直接问「我的排版偏好是什么」。
- `.ps1` 无 BOM 会被 5.1 当 GBK 解码，中文语法报错。见 `me/environment.md`。
- 只在 DSH 里好用不算成功——它本来就是零配置。真正的验证点是 Claude Code 或
  buddy 那边也能读到。
