param(
    [switch]$StopOnly,
    [switch]$WithStudio
)

# 兼容 --WithStudio 写法
if ($args -contains '--WithStudio') {
    $WithStudio = $true
}

$FRONTEND_PORT = 3000
$BACKEND_PORT = 3001
$STUDIO_PORT = 5555
$PROJECT_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$FRONTEND_DIR = Join-Path $PROJECT_ROOT "frontend"
$BACKEND_DIR = Join-Path $PROJECT_ROOT "backend"

$global:backendPid = $null
$global:frontendPid = $null
$global:studioPid = $null
$global:exiting = $false

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Level) {
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "ERROR"   { "Red" }
        default   { "White" }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

function Stop-PidTree {
    param([int]$Pid)
    try {
        $result = taskkill /F /T /PID $Pid 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "已终止进程树 PID=$Pid" "SUCCESS"
        }
    } catch { }
}

function Stop-Port {
    param([int]$Port)
    try {
        # 更健壮的正则：匹配指定端口且处于LISTENING状态的行
        $lines = netstat -ano -p TCP 2>$null | Select-String ":$Port\s" | Select-String "LISTENING"
        foreach ($line in $lines) {
            $lineStr = $line.ToString().Trim()
            $parts = $lineStr -split '\s+'
            # netstat输出格式: 协议 本地地址 远程地址 状态 PID
            # 例如: TCP 0.0.0.0:3001 0.0.0.0:0 LISTENING 12345
            if ($parts.Count -ge 5) {
                $pidStr = $parts[-1]
                if ($pidStr -match '^\d+$' -and [int]$pidStr -ne 0) {
                    try {
                        taskkill /F /T /PID $pidStr 2>$null | Out-Null
                        Write-Log "已终止端口 :$Port 上的进程 PID=$pidStr" "SUCCESS"
                    } catch { }
                }
            }
        }
    } catch { }
}

function Cleanup {
    if ($global:exiting) { return }
    $global:exiting = $true
    Write-Host ""
    Write-Log "正在停止服务..." "WARNING"

    if ($global:backendPid) { Stop-PidTree -Pid $global:backendPid }
    if ($global:frontendPid) { Stop-PidTree -Pid $global:frontendPid }
    if ($global:studioPid) { Stop-PidTree -Pid $global:studioPid }

    # 等待进程完全退出
    Start-Sleep -Milliseconds 500

    # 兜底：按端口杀残留进程
    Stop-Port -Port $BACKEND_PORT
    Stop-Port -Port $FRONTEND_PORT
    Stop-Port -Port $STUDIO_PORT

    Write-Log "所有服务已停止" "SUCCESS"
}

function Stop-All {
    Stop-Port -Port $BACKEND_PORT
    Stop-Port -Port $FRONTEND_PORT
    Stop-Port -Port $STUDIO_PORT
    Write-Log "所有服务已停止" "SUCCESS"
}

# 注册 Ctrl+C 事件处理
Register-ObjectEvent -InputObject ([Console]) -EventName CancelKeyPress -Action {
    $global:exiting = $true
    Write-Host ""
    Write-Log "收到 Ctrl+C 信号" "WARNING"
    Cleanup
    [Environment]::Exit(0)
} | Out-Null

if ($StopOnly) {
    Stop-All
    exit 0
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        边际结构项目启动脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "前端端口: $FRONTEND_PORT" -ForegroundColor White
Write-Host "后端端口: $BACKEND_PORT" -ForegroundColor White
Write-Host "工作区目录: $PROJECT_ROOT"
Write-Host ""

Write-Log "清理端口占用..."
Stop-Port -Port $BACKEND_PORT
Stop-Port -Port $FRONTEND_PORT
Stop-Port -Port $STUDIO_PORT
Start-Sleep -Milliseconds 300

# 检查并安装依赖
function Ensure-NodeModules {
    param([string]$Dir)
    $nm = Join-Path $Dir "node_modules"
    if (-not (Test-Path $nm)) {
        Write-Log "安装依赖: $Dir ..."
        Push-Location $Dir
        npm install 2>&1 | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
        Pop-Location
    }
}

Ensure-NodeModules -Dir $BACKEND_DIR
Ensure-NodeModules -Dir $FRONTEND_DIR

Write-Log "启动后端服务..."
$backendProc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run dev" -WorkingDirectory $BACKEND_DIR -WindowStyle Hidden -PassThru
$global:backendPid = $backendProc.Id

Start-Sleep -Seconds 2

Write-Log "启动前端服务..."
$frontendProc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run dev" -WorkingDirectory $FRONTEND_DIR -WindowStyle Hidden -PassThru
$global:frontendPid = $frontendProc.Id

Start-Sleep -Seconds 2

# 启动 Prisma Studio（可选）
if ($WithStudio) {
    Write-Log "启动 Prisma Studio..."
    $studioProc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npx prisma studio --port $STUDIO_PORT" -WorkingDirectory $BACKEND_DIR -WindowStyle Hidden -PassThru
    $global:studioPid = $studioProc.Id
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "        服务启动成功！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "前端地址: " -NoNewline; Write-Host "http://localhost:$FRONTEND_PORT" -ForegroundColor Cyan
Write-Host "后端地址: " -NoNewline; Write-Host "http://localhost:$BACKEND_PORT" -ForegroundColor Cyan
if ($WithStudio) {
    Write-Host "Prisma Studio: " -NoNewline; Write-Host "http://localhost:$STUDIO_PORT" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "按 Ctrl+C 停止所有服务" -ForegroundColor Yellow
Write-Host ""

# 简单轮询 + finally 清理
try {
    while ($true) {
        Start-Sleep -Seconds 1
        if ($global:exiting) { break }
        $backendAlive = !$backendProc.HasExited
        $frontendAlive = !$frontendProc.HasExited
        if (-not $backendAlive -and -not $frontendAlive) { break }
        if (-not $backendAlive) { Write-Log "后端进程已退出" "WARNING" }
        if (-not $frontendAlive) { Write-Log "前端进程已退出" "WARNING" }
    }
} finally {
    if (!$global:exiting) {
        Cleanup
    }
    [Environment]::Exit(0)
}
