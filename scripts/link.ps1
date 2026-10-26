<#
    把本仓库接入各个 AI 工具，让它们每次开工都先读 AGENTS.md。

      powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1
      powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1 -DryRun
      powershell -ExecutionPolicy Bypass -File .\scripts\link.ps1 -Repo D:\brain

    设计取舍：
    - 不建符号链接。Windows 建软链要开发者模式或管理员，还不能跨盘；
      改成「入口文件里写路径」，任何权限下都能跑，macOS/Linux 版脚本同理。
    - **不覆盖别人的配置。** 已有的 CLAUDE.md / GEMINI.md 只在末尾追加一段指针；
      文件里已经有本仓库路径就跳过，所以重复跑是安全的。
    - 真需要改动已有文件时先备份到 %USERPROFILE%\.brain-backup-<时间>\。
    - 兼容 Windows PowerShell 5.1（本机只有 5.1，没有 pwsh 7）。
      注意：本文件必须存成 UTF-8 **带 BOM**，否则 5.1 会按 GBK 解码、中文全乱。
    - 各工具的全局文件路径会随版本变化。写完开一个新会话验证；
      没读到就把入口内容粘进该工具的「全局指令 / Rules / Memory」设置。
#>
[CmdletBinding()]
param(
    [string]$Repo,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$script:noBom = New-Object System.Text.UTF8Encoding($false)

function Write-TextNoBom {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $script:noBom)
}

function Read-TextAuto {
    param([string]$Path)
    return [System.IO.File]::ReadAllText($Path, $script:noBom)
}

if (-not $Repo) { $Repo = Split-Path -Parent $PSScriptRoot }
$Repo = (Resolve-Path -LiteralPath $Repo).Path.TrimEnd('\', '/')
$entry = Join-Path $Repo 'AGENTS.md'
if (-not (Test-Path -LiteralPath $entry)) {
    throw "在 $Repo 里找不到 AGENTS.md。-Repo 指错了？"
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $HOME ".brain-backup-$stamp"

# 追加式目标：已有文件只在末尾追加一段指针，原有内容一个字都不动
$appendTargets = @(
    @{ Name = 'Claude Code'; Path = (Join-Path $HOME '.claude\CLAUDE.md'); Line = "@$entry" }
    @{ Name = 'Codex CLI';   Path = (Join-Path $HOME '.codex\AGENTS.md');  Line = "开工前先读这个文件并遵守它：$entry" }
    @{ Name = 'Gemini CLI';  Path = (Join-Path $HOME '.gemini\GEMINI.md'); Line = "@$entry" }
)

# 本脚本独占的目标：整文件由脚本管理
$cursorBody = @"
---
description: 个人档案入口（由 brain 仓库的 scripts/link.ps1 生成，重跑会覆盖）
alwaysApply: true
---

开工前先读这个文件，并遵守里面的路由表和写入协议：
$entry
"@
$ownedTargets = @(
    @{ Name = 'Cursor'; Path = (Join-Path $HOME '.cursor\rules\brain.mdc'); Body = $cursorBody }
)

Write-Host "仓库：$Repo"
Write-Host "入口：$entry"
Write-Host ''

$added = 0; $skipped = 0; $replaced = 0

foreach ($t in $appendTargets) {
    $dir = Split-Path -Parent $t.Path
    if (-not (Test-Path -LiteralPath $dir)) {
        if ($DryRun) { Write-Host "  [dry] 新建目录 $dir" }
        else { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    }

    if (-not (Test-Path -LiteralPath $t.Path)) {
        $content = "# 个人档案入口（由 brain 仓库的 scripts/link.ps1 生成）`r`n`r`n$($t.Line)`r`n"
        Write-Host "  新建  $($t.Name)  $($t.Path)"
        if (-not $DryRun) { Write-TextNoBom -Path $t.Path -Content $content }
        $added++
        continue
    }

    $existing = Read-TextAuto -Path $t.Path
    if ($existing.Contains($entry)) {
        Write-Host "  已就绪  $($t.Name)  （文件里已有指向本仓库的指针，跳过）" -ForegroundColor DarkGray
        $skipped++
        continue
    }

    # 只在末尾追加，不动原文
    $backup = Join-Path $backupRoot ($t.Path.Substring($HOME.Length).TrimStart('\'))
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
        Copy-Item -LiteralPath $t.Path -Destination $backup -Force
    }
    $content = $existing.TrimEnd() + "`r`n`r`n# 个人档案入口（以下由 brain 仓库的 scripts/link.ps1 追加）`r`n$($t.Line)`r`n"
    Write-Host "  追加  $($t.Name)  $($t.Path)" -ForegroundColor Yellow
    Write-Host "        原有内容未改；备份在 $backup" -ForegroundColor Yellow
    if (-not $DryRun) { Write-TextNoBom -Path $t.Path -Content $content }
    $added++
}

foreach ($t in $ownedTargets) {
    $dir = Split-Path -Parent $t.Path
    if (-not (Test-Path -LiteralPath $dir)) {
        if ($DryRun) { Write-Host "  [dry] 新建目录 $dir" }
        else { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    }

    if (Test-Path -LiteralPath $t.Path) {
        $existing = Read-TextAuto -Path $t.Path
        if ($existing.Contains($entry)) {
            Write-Host "  已就绪  $($t.Name)  $($t.Path)" -ForegroundColor DarkGray
            $skipped++
            continue
        }
        $backup = Join-Path $backupRoot ($t.Path.Substring($HOME.Length).TrimStart('\'))
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
            Copy-Item -LiteralPath $t.Path -Destination $backup -Force
        }
        Write-Host "  覆盖  $($t.Name)  $($t.Path)（原文件备份在 $backup）" -ForegroundColor Yellow
        $replaced++
    }
    else {
        Write-Host "  新建  $($t.Name)  $($t.Path)"
        $added++
    }
    if (-not $DryRun) { Write-TextNoBom -Path $t.Path -Content ($t.Body + "`r`n") }
}

Write-Host ''
Write-Host "完成。新建 $added 个，跳过 $skipped 个，覆盖 $replaced 个。"
Write-Host ''
Write-Host '接下来：'
Write-Host '  1. 验证真读到了 —— 开一个【新】会话，直接问：「我的排版偏好是什么？」'
Write-Host '     答得出来就通了。'
Write-Host '  2. 某个工具没反应 —— 它的全局配置路径可能变了。把入口内容粘进它的'
Write-Host '     「全局指令 / Rules / Memory」设置，或查它的官方文档确认路径：'
Write-Host "        $entry"
Write-Host '  3. 别的代码仓库也要用 —— 在那边根目录建 AGENTS.md，只写一行：'
Write-Host "       开工前先读 $entry，按它的路由和写入协议工作。"
