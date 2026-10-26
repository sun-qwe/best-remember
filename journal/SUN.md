# SUN 的日志

## 2026-10-26 SUN
- 做了：建了 brain 仓库骨架（AGENTS.md 路由 + me/ 模板 + 接工具脚本）
- 定了：入口用「写路径的入口文件」而不是符号链接，跨盘、免管理员；脚本按 PowerShell 5.1 写
- 下次：填 me/identity.md 和 me/preferences.md，再跑 scripts\link.ps1
## 2026-10-26 SUN
- 做了：按真实情况填好 AGENTS.md、me/identity.md、me/preferences.md、me/environment.md（环境栏是实测的）
- 定了：脚本按 PowerShell 5.1 写；入口只追加不覆盖；先只服务 DSH + buddy 两个主力
- 下次：建 private repo 推上去；跑 link.ps1 接 Claude Code / Cursor
## 2026-10-26 SUN
- 做了：给写入协议加了快慢双通道；新增 scripts/distill-prompt.md（每周蒸馏提示词）
- 定了：想法变化走 journal 立刻生效，me/ 只在每周确认后才改；冲突必须报告不许静默合并
- 下次：跑 link.ps1 验证跨工具；推 GitHub
## 2026-10-26 SUN（事故）
- 做了：11:34 前后发现 .git 目录消失，3 个提交历史丢失；文件内容完整，已重建仓库并重新提交
- 定了：桌面上放 git 仓库必须配 remote，否则等于没有版本控制；先推 GitHub 再考虑搬目录
- 下次：确认 .git 消失的原因（用户操作？清理工具？），并在 GitHub 上建 private repo
## 2026-10-26 迁移
- 做了：仓库从 D:\桌面2\大脑 迁到 D:\桌面2\best-remember（远端 sun-qwe/best-remember）；同步了事故记录
- 定了：best-remember 是唯一副本，路径不含中文；大脑目录改名保留一周后删除
- 下次：在 best-remember 里开 DSH 新会话验证；跑 link.ps1 让指针指向新路径
## 2026-10-26 再次迁移
- 做了：仓库迁到 D:\yupi-ke\git-branch\best-remember；更新 environment/brain 文档路径；重跑 link.ps1 修死链
- 定了：仓库不再放桌面；每次搬目录后必须重跑 link.ps1，否则工具静默失效
- 下次：在新目录开 DSH 验证；别再把工作区和仓库放同一个会被删的目录