# 档案编码修复脚本 v2.0 - 根据 PRT-0001 v4.0
# 此脚本会系统修复所有文件的编码问题

$ErrorActionPreference = "Continue"
$ContentPath = "d:\Github\TheMarginalStructure\content\档案"

Write-Host "=== 开始档案编码修复 (PRT-0001 v4.0) ===" -ForegroundColor Green

# ============================================================
# 1. 修复文件内容中的旧编码引用
# ============================================================

Write-Host "`n[步骤 1] 修复文件内容中的编码引用..." -ForegroundColor Cyan

# 按顺序定义编码替换规则（重要：长代码优先，避免部分匹配）
$CodeReplacements = [ordered]@{
    # === 对象档案/阈界档案 (TF → TMS) ===
    "TF-L734-LND" = "TMS-L0734"
    "TF-L234-LND" = "TMS-L0234"
    "TF-O881-COG" = "TMS-O0881"
    "TF-E771-ENT" = "TMS-E0771"
    "TF-O442-OBJ" = "TMS-O0442-01"
    "TF-O442-TMS" = "TMS-O0442-01"
    "TF-O2847-NEG" = "TMS-O2847"
    "TF-L735-LND" = "TMS-L0735"
    "TF-T-112-SIL" = "TMS-T0112"
    "TF-T112-SIL" = "TMS-T0112"
    "TF-V990-TMP" = "TMS-P0990"
    "TF-O-001-TMS" = "TMS-O0001"
    
    # === 勘探报告 (EL → EXP) ===
    "EL-Gamma-L234-COG" = "EXP-L0234"
    "EL-Dreamweaver-O881-COG" = "EXP-O0881"
    "EL-Guardian-E771-COG" = "EXP-E0771"
    "EL-Gamma-L734-COG" = "EXP-L0734"
    "EL-Beta-O442-SPC" = "EXP-O0442"
    "EL-Gamma-L735-PHY" = "EXP-L0735"
    "EL-Guardian-B112-TMP" = "EXP-T0112"
    "EL-Gamma-L234-COG-S2" = "EXP-L0234-S2"
    
    # === 医疗报告 (MHR → MED) ===
    "MHR-L734-PSY-DCarter" = "MED-L0734"
    "MHR-E771-PSY" = "MED-E0771"
    "MHR-V990-PSY" = "MED-P0990"
    "MHR-GEN-PSY-AKay" = "MED-O0881"
    "MHR-L234-COG" = "MED-L0234"
    "MHR-B112-TMP" = "MED-T0112"
    
    # === 理论文件 (TD → THY) ===
    "TD-O881-COG" = "THY-O0881"
    "TD-L234-COG" = "THY-L0234"
    "TD-L234-MEM" = "THY-L0234"
    
    # === 通信记录 (COM → EVT) ===
    "COM-O2847-INT" = "EVT-O2847-COM"
    "COM-B112-TMP" = "EVT-T0112-COM"
    "COM-L234-INT" = "EVT-L0234-COM"
    
    # === 事件报告 (IR → EVT) ===
    "IR-V990-INC" = "EVT-P0990-INC"
    "IR-V-990-INC" = "EVT-P0990-INC"
    "IR-B112-TMP" = "EVT-T0112-INC"
    "IR-L234-COG" = "EVT-L0234-INC"
    
    # === 协议手册 (PRT) ===
    "PRT-ARC-QRY-COD" = "PRT-0002"
    "PRT-LAB-SAF-SOP" = "PRT-0003"
    "PRT-ARC-SOP-ARC" = "PRT-0004"
    "PRT-ARC-RUL-COD" = "PRT-0001"
    "PRT-ARC-CLS-THD" = "PRT-0005"
    "PRT-ARC-SOP" = "PRT-0004"
    "PRT-LAB-SOP-SAF" = "PRT-0003"
    "PRT-GEN-SEC" = "PRT-0006"
    
    # === 人事档案 (HR) ===
    "HR-MED-DCarter-RES" = "HR-400001"
    "HR-ARC-ASharma-RES" = "HR-300002"
    "HR-ARC-ASharma-BIO" = "HR-300002-BIO"
    "HR-ARC-ASharma" = "HR-300002"
    
    # === 实验记录 (EXP) ===
    "EXP-O442-PHY" = "EXP-O0442"
    "EXP-A512-BIO" = "EXP-A0512"
    "EXP-A512-BIO-S2" = "EXP-A0512-S2"
    "EXP-B0112" = "EXP-T0112"
    "EXP-A0512-BIO" = "EXP-A0512"
    "EXP-A0512-BIO-S2" = "EXP-A0512-S2"
    
    # === 阈界代码标准化 (添加前导零，V→P类型转换) ===
    "TMS-L234" = "TMS-L0234"
    "TMS-L734" = "TMS-L0734"
    "TMS-O881" = "TMS-O0881"
    "TMS-E771" = "TMS-E0771"
    "TMS-O442" = "TMS-O0442"
    "TMS-O2847" = "TMS-O2847"
    "TMS-L735" = "TMS-L0735"
    "TMS-V990" = "TMS-P0990"
    "TMS-T112" = "TMS-T0112"
    "TMS-B112" = "TMS-T0112"
    "TMS-R009" = "TMS-R0009"
    "TMS-A512" = "TMS-A0512"
}

# 获取所有 markdown 文件
$AllMdFiles = Get-ChildItem -Path $ContentPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue
$ModifiedFiles = 0
$TotalReplacements = 0

foreach ($File in $AllMdFiles) {
    try {
        $Content = Get-Content -Path $File.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        if ($null -eq $Content) { continue }
        
        $OriginalContent = $Content
        $FileReplacements = 0
        
        foreach ($OldCode in $CodeReplacements.Keys) {
            $NewCode = $CodeReplacements[$OldCode]
            $CountBefore = ([regex]::Matches($Content, [regex]::Escape($OldCode))).Count
            
            # 替换 wiki-links [[OLD]] 格式
            $Content = $Content -replace "\[\[$([regex]::Escape($OldCode))\]\]", "[[$NewCode]]"
            # 替换纯文本引用
            $Content = $Content -replace "(?<!\[)\[?(?<!\[\[)$([regex]::Escape($OldCode))\]?(?!\])", $NewCode
            
            $CountAfter = ([regex]::Matches($Content, [regex]::Escape($OldCode))).Count
            $FileReplacements += ($CountBefore - $CountAfter)
        }
        
        if ($Content -ne $OriginalContent) {
            Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline -Force
            $ModifiedFiles++
            $TotalReplacements += $FileReplacements
            Write-Host "  [修复] $($File.Name) ($FileReplacements 处)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "  [错误] 处理 $($File.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`n共修复了 $ModifiedFiles 个文件，$TotalReplacements 处编码引用" -ForegroundColor Green

# ============================================================
# 2. 重命名文件
# ============================================================

Write-Host "`n[步骤 2] 重命名文件..." -ForegroundColor Cyan

$FileRenames = @(
    # 对象档案 -> 阈界档案
    @{OldName = "TF-L734-LND.md"; NewName = "TMS-L0734.md"},
    @{OldName = "TF-L234-LND.md"; NewName = "TMS-L0234.md"},
    @{OldName = "TF-O881-COG.md"; NewName = "TMS-O0881.md"},
    @{OldName = "TF-E771-ENT.md"; NewName = "TMS-E0771.md"},
    @{OldName = "TF-O442-OBJ.md"; NewName = "TMS-O0442-01.md"},
    @{OldName = "TF-O2847-NEG.md"; NewName = "TMS-O2847.md"},
    @{OldName = "TF-L735-LND.md"; NewName = "TMS-L0735.md"},
    @{OldName = "TF-T-112-SIL.md"; NewName = "TMS-T0112.md"},
    
    # 勘探报告
    @{OldName = "EL-Dreamweaver-O881-COG.md"; NewName = "EXP-O0881.md"},
    @{OldName = "EL-Gamma-L234-COG.md"; NewName = "EXP-L0234.md"},
    @{OldName = "EL-Guardian-E771-COG.md"; NewName = "EXP-E0771.md"},
    @{OldName = "EL-Gamma-L734-COG.md"; NewName = "EXP-L0734.md"},
    @{OldName = "EL-Beta-O442-SPC.md"; NewName = "EXP-O0442.md"},
    @{OldName = "EL-Gamma-L735-PHY.md"; NewName = "EXP-L0735.md"},
    
    # 医疗报告
    @{OldName = "MHR-L734-PSY-DCarter.md"; NewName = "MED-L0734.md"},
    @{OldName = "MHR-E771-PSY.md"; NewName = "MED-E0771.md"},
    @{OldName = "MHR-V990-PSY.md"; NewName = "MED-P0990.md"},
    
    # 理论文件
    @{OldName = "TD-O881-COG.md"; NewName = "THY-O0881.md"},
    @{OldName = "TD-L234-COG.md"; NewName = "THY-L0234.md"},
    
    # 通信记录
    @{OldName = "COM-O2847-INT.md"; NewName = "EVT-O2847-COM.md"},
    
    # 事件报告
    @{OldName = "IR-V990-INC.md"; NewName = "EVT-P0990-INC.md"},
    
    # 协议手册
    @{OldName = "代码查询手册 (PRT-ARC-QRY-COD).md"; NewName = "PRT-0002.md"},
    @{OldName = "实验室安全操作规程 (PRT-LAB-SAF-SOP).md"; NewName = "PRT-0003.md"},
    @{OldName = "档案管理规范 (PRT-ARC-SOP-ARC).md"; NewName = "PRT-0004.md"},
    @{OldName = "档案编码规则 (PRT-0001).md"; NewName = "PRT-0001.md"},
    @{OldName = "阈界分类标准 (PRT-ARC-CLS-THD).md"; NewName = "PRT-0005.md"},
    
    # 人事档案
    @{OldName = "HR-MED-DCarter-RES.md"; NewName = "HR-400001.md"},
    
    # 实验记录
    @{OldName = "EXP-O442-PHY.md"; NewName = "EXP-O0442.md"}
)

$RenamedCount = 0
foreach ($Rename in $FileRenames) {
    try {
        $Files = Get-ChildItem -Path $ContentPath -Recurse -Filter $Rename.OldName -ErrorAction SilentlyContinue
        foreach ($File in $Files) {
            $NewPath = Join-Path $File.DirectoryName $Rename.NewName
            if ($File.FullName -ne $NewPath) {
                Rename-Item -Path $File.FullName -NewName $Rename.NewName -Force -ErrorAction Stop
                Write-Host "  [重命名] $($Rename.OldName) -> $($Rename.NewName)" -ForegroundColor Yellow
                $RenamedCount++
            }
        }
    }
    catch {
        Write-Host "  [错误] 重命名 $($Rename.OldName): $_" -ForegroundColor Red
    }
}

Write-Host "`n共重命名了 $RenamedCount 个文件" -ForegroundColor Green

# ============================================================
# 3. 更新协议编码规则文件中的元数据
# ============================================================

Write-Host "`n[步骤 3] 修复 PRT-0001 文件自身编码..." -ForegroundColor Cyan

$PRT0001Path = Join-Path $ContentPath "协议手册 (Protocol Manual - PRT)\PRT-0001.md"
if (Test-Path $PRT0001Path) {
    $Content = Get-Content -Path $PRT0001Path -Raw -Encoding UTF8
    # 确保底部元数据正确
    $Content = $Content -replace "\*文档编码：PRT-ARC-RUL-COD\*", "*文档编码：PRT-0001*"
    $Content = $Content -replace "\*文档编码：PRT-0001\.md\*", "*文档编码：PRT-0001*"
    Set-Content -Path $PRT0001Path -Value $Content -Encoding UTF8 -NoNewline -Force
    Write-Host "  [修复] PRT-0001.md 元数据" -ForegroundColor Yellow
}

Write-Host "`n=== 编码修复完成 ===" -ForegroundColor Green
Write-Host "`n修复摘要:" -ForegroundColor Cyan
Write-Host "  - 内容修复: $ModifiedFiles 个文件, $TotalReplacements 处引用" -ForegroundColor Green
Write-Host "  - 文件重命名: $RenamedCount 个文件" -ForegroundColor Green
Write-Host "`n建议操作:" -ForegroundColor Yellow
Write-Host "  1. 检查修复后的文件内容是否正确" -ForegroundColor White
Write-Host "  2. 验证所有 wiki-link 是否可正常解析" -ForegroundColor White
Write-Host "  3. 运行 'git status' 查看所有变更" -ForegroundColor White
Write-Host "  4. 确认无误后提交更改" -ForegroundColor White
