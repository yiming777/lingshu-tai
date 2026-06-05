# ═══════════════════════════════════════════════════════════════
# 灵枢台 · 一键安装脚本 (Windows PowerShell)
# 将 11 个 TCM Skill + 知识底座安装到 OpenClaw 插件目录
# ═══════════════════════════════════════════════════════════════
param(
  [switch]$DryRun,
  [switch]$SkillsOnly,
  [switch]$WorkspaceOnly,
  [switch]$NoRestart,
  [switch]$Help
)

if ($Help) {
  Write-Host "灵枢台 安装脚本 (Windows)"
  Write-Host ""
  Write-Host "用法: powershell -ExecutionPolicy Bypass -File install.ps1 [选项]"
  Write-Host ""
  Write-Host "选项:"
  Write-Host "  -DryRun          模拟运行，不实际复制"
  Write-Host "  -SkillsOnly      只安装 Skills"
  Write-Host "  -WorkspaceOnly   只安装 workspace 文件"
  Write-Host "  -NoRestart       安装后不重启 Gateway"
  Write-Host "  -Help            显示帮助"
  exit 0
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsSrc = Join-Path $ScriptDir "skills"
$WorkspaceSrc = Join-Path $ScriptDir "workspace"

# --------------- 检测环境 ---------------
Write-Host "灵枢台 · 安装程序" -ForegroundColor Cyan
Write-Host ""

Write-Host "  系统: Windows" -ForegroundColor Green

# 检测插件目录
$HomeDir = $env:USERPROFILE
$PluginDir = Join-Path $HomeDir ".openclaw\plugin-skills"

if (-not (Test-Path (Join-Path $HomeDir ".openclaw"))) {
  Write-Host "  ⚠ 未检测到 ~/.openclaw 目录。" -ForegroundColor Yellow
  Write-Host "  请先安装 OpenClaw：npm install -g openclaw && openclaw configure"
  exit 1
}

Write-Host "  插件目录: $PluginDir" -ForegroundColor Green

# 检测 workspace
$WorkspaceDir = Join-Path $HomeDir ".openclaw\workspace"
Write-Host "  工作区: $WorkspaceDir" -ForegroundColor Green
Write-Host ""

# --------------- 安装 Skills ---------------
function Install-Skills {
  Write-Host "📦 安装灵枢台 Skills..." -ForegroundColor White

  if (-not (Test-Path $PluginDir)) {
    New-Item -ItemType Directory -Path $PluginDir -Force | Out-Null
  }

  $count = 0
  Get-ChildItem $SkillsSrc -Directory -Filter "tcm*" | ForEach-Object {
    $name = $_.Name
    $dest = Join-Path $PluginDir $name

    if ($DryRun) {
      Write-Host "  [DRY] $name → $dest" -ForegroundColor Yellow
    } else {
      if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
      Copy-Item -Recurse $_.FullName $dest
      Write-Host "  ✓ $name" -ForegroundColor Green
    }
    $count++
  }

  Write-Host ""
  Write-Host "  已安装 $count 个 Skill" -ForegroundColor Green
}

# --------------- 安装 Workspace ---------------
function Install-Workspace {
  Write-Host "📝 安装 Workspace 文件..." -ForegroundColor White

  if (-not (Test-Path $WorkspaceSrc)) {
    Write-Host "  ⊘ 未找到 workspace/ 目录，跳过" -ForegroundColor Yellow
    return
  }

  if (-not (Test-Path $WorkspaceDir)) {
    New-Item -ItemType Directory -Path $WorkspaceDir -Force | Out-Null
  }
  $memDir = Join-Path $WorkspaceDir "memory"
  if (-not (Test-Path $memDir)) {
    New-Item -ItemType Directory -Path $memDir -Force | Out-Null
  }

  $copied = 0
  @("AGENTS.md","SOUL.md","IDENTITY.md","USER.md","MEMORY.md","TOOLS.md","HEARTBEAT.md") | ForEach-Object {
    $src = Join-Path $WorkspaceSrc $_
    if (Test-Path $src) {
      if (-not $DryRun) {
        Copy-Item $src $WorkspaceDir -Force
      }
      Write-Host "  ✓ $_" -ForegroundColor Green
      $copied++
    }
  }

  Write-Host ""
  Write-Host "  已安装 $copied 个 Workspace 文件" -ForegroundColor Green
}

# --------------- 重启 Gateway ---------------
function Restart-Gateway {
  if ($DryRun) {
    Write-Host "  [DRY] 跳过 Gateway 重启" -ForegroundColor Yellow
    return
  }
  Write-Host "🔄 重启 Gateway..." -ForegroundColor White
  try {
    openclaw gateway restart 2>$null
    Write-Host "  ✓ Gateway 已重启" -ForegroundColor Green
  } catch {
    Write-Host "  ⚠ Gateway 重启失败，请手动执行: openclaw gateway restart" -ForegroundColor Yellow
  }
}

# --------------- 执行 ---------------
if ($WorkspaceOnly) {
  Install-Workspace
} elseif ($SkillsOnly) {
  Install-Skills
} else {
  Install-Skills
  Write-Host ""
  Install-Workspace
}

if (-not $NoRestart -and -not $WorkspaceOnly -and -not $DryRun) {
  Write-Host ""
  Restart-Gateway
}

# --------------- 完成 ---------------
Write-Host ""
Write-Host "═══════════════════════════════════════" -ForegroundColor Green
Write-Host "  灵枢台 安装完成 🧬⚡🌿" -ForegroundColor Green
Write-Host "═══════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  启动命令："
Write-Host "    openclaw gateway restart" -ForegroundColor Cyan
Write-Host ""
Write-Host "  验证安装："
Write-Host "    dir `$env:USERPROFILE\.openclaw\plugin-skills\tcm*" -ForegroundColor Cyan
Write-Host ""
Write-Host "  中控台："
Write-Host "    cd lingshu-tai\dashboard && node server.js" -ForegroundColor Cyan
Write-Host "    http://localhost:3333" -ForegroundColor Cyan
Write-Host ""
