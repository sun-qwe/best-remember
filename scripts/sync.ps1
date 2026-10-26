<#
    同步本仓库。

      powershell -ExecutionPolicy Bypass -File .\scripts\sync.ps1              # 拉取
      powershell -ExecutionPolicy Bypass -File .\scripts\sync.ps1 -Push "说明"  # 提交并推送
      powershell -ExecutionPolicy Bypass -File .\scripts\sync.ps1 -Status      # 看状态

    挂成登录时自动拉取（当前用户即可，不需要管理员）：
      schtasks /create /tn "brain-pull" /sc onlogon /f /tr "powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File %USERPROFILE%\brain\scripts\sync.ps1"

    规矩：同一时间只在一台机器上写。开工先拉，收工再推。
    兼容 Windows PowerShell 5.1。
#>
[CmdletBinding()]
param(
    [switch]$Pull,
    [string]$Push,
    [switch]$Status
)

$ErrorActionPreference = 'Stop'
$Repo = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath (Join-Path $Repo '.git'))) {
    throw "$Repo 不是 git 仓库。先 git init，或者确认脚本在仓库的 scripts\ 目录下。"
}

function Invoke-Git {
    param([string[]]$GitArgs)
    & git -C $Repo @GitArgs
    if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') 失败（退出码 $LASTEXITCODE）" }
}

if ($Status) {
    Invoke-Git @('status', '-sb')
    # 5.1 里 `2>$null` 会在 $ErrorActionPreference='Stop' 下抛 NativeCommandError，用 *> 收口
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & git -C $Repo rev-parse --verify HEAD *> $null
    $hasCommit = ($LASTEXITCODE -eq 0)
    $ErrorActionPreference = $prev
    if ($hasCommit) {
        Write-Host ''
        Invoke-Git @('log', '--oneline', '-8')
    }
    else {
        Write-Host ''
        Write-Host '还没有任何提交。'
    }
    return
}

if ($PSBoundParameters.ContainsKey('Push')) {
    Invoke-Git @('add', '-A')

    # 兜底：拦一下明显是密钥的文件
    $staged = @(& git -C $Repo diff --cached --name-only)
    $risky = $staged | Where-Object { $_ -match '(?i)(^|/)(\.env|secrets?/|credentials)|\.(pem|key|p12|pfx)$|id_(rsa|ed25519)$' }
    if ($risky) {
        Invoke-Git @('reset') | Out-Null
        Write-Host '拒绝提交：这些文件看着像密钥——' -ForegroundColor Red
        $risky | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
        Write-Host '把它们移出暂存区或加进 .gitignore 再试。' -ForegroundColor Red
        exit 1
    }

    $realStaged = @($staged | Where-Object { $_ })
    if ($realStaged.Count -eq 0) {
        Write-Host '没有改动，不需要提交。'
    }
    else {
        $msg = if ([string]::IsNullOrWhiteSpace($Push)) { "brain: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" } else { $Push }
        Invoke-Git @('commit', '-m', $msg)
        Write-Host "已提交：$msg"
    }

    Invoke-Git @('pull', '--rebase', '--autostash')
    Invoke-Git @('push')
    Write-Host '已推送。'
    return
}

Write-Host "拉取 $Repo ..."
Invoke-Git @('pull', '--rebase', '--autostash')
Write-Host '已是最新。'
