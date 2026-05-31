# 档案编码修复脚本 - 根据 PRT-0001 v4.0
# 此脚本会修复所有文件的编码问题

$ContentPath = "d:\Github\TheMarginalStructure\content\档案"

Write-Host "=== 开始档案编码修复 ===" -ForegroundColor Green

# ============================================================
# 1. 修复文件内容中的旧编码引用
# ============================================================

Write-Host "`n[步骤 1] 修复文件内容中的编码引用..." -ForegroundColor Cyan

# 定义编码替换规则
$CodeReplacements = @{
    # 旧代码 -> 新代码
    "TF-L734-LND" = "TMS-L0734"
    "TF-L234-LND" = "TMS-L0234"
    "TF-O881-COG" = "TMS-O0881"
    "TF-E771-ENT" = "TMS-E0771"
    "TF-O442-OBJ" = "TMS-O0442-01"
    "TF-O442-TMS" = "TMS-O0442-01"
    "TF-O2847-NEG" = "TMS-O2847"
    "TF-L735-LND" = "TMS-L0735"
    "TF-T112-SIL" = "TMS-T0112"
    "TF-T-112-SIL" = "TMS-T0112"
    
    "EL-Gamma-L234-COG" = "EXP-L0234"
    "EL-Dreamweaver-O881-COG" = "EXP-O0881"
    "EL-Guardian-E771-COG" = "EXP-E0771"
    "EL-Gamma-L734-COG" = "EXP-L0734"
    "EL-Beta-O442-SPC" = "EXP-O0442"
    "EL-Gamma-L735-PHY" = "EXP-L0735"
    
    "MHR-L734-PSY-DCarter" = "MED-L0734"
    "MHR-E771-PSY" = "MED-E0771"
    "MHR-V990-PSY" = "MED-P0990"
    "MHR-GEN-PSY-AKay" = "MED-O0881"
    
    "TD-O881-COG" = "THY-O0881"
    "TD-L234-COG" = "THY-L0234"
    
    "COM-O2847-INT" = "EVT-O2847-COM"
    "COM-O2847-INT" = "EVT-O2847-COM"
    
    "IR-V990-INC" = "EVT-P0990-INC"
    "IR-V-990-INC" = "EVT-P0990-INC"
    
    "HR-MED-DCarter-RES" = "HR-400001"
    
    "EXP-O442-PHY" = "EXP-O0442"
    
    "PRT-ARC-QRY-COD" = "PRT-0002"
    "PRT-LAB-SAF-SOP" = "PRT-0003"
    "PRT-ARC-SOP-ARC" = "PRT-0004"
    "PRT-ARC-RUL-COD" = "PRT-0001"
    "PRT-ARC-CLS-THD" = "PRT-0005"
    
    # 阈界代码标准化 (添加前导零)
    "TMS-L234" = "TMS-L0234"
    "TMS-L734" = "TMS-L0734"
    "TMS-O881" = "TMS-O0881"
    "TMS-E771" = "TMS-E0771"
    "TMS-O442" = "TMS-O0442"
    "TMS-O2847" = "TMS-O2847"
    "TMS-L735" = "TMS-L0735"
    "TMS-V990" = "TMS-P0990"
    "TMS-T112" = "TMS-T0112"
}

# 获取所有 markdown 文件
$AllMdFiles = Get-ChildItem -Path $ContentPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue
$ModifiedFiles = 0

foreach ($File in $AllMdFiles) {
    $Content = Get-Content -Path $File.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $Content) { continue }
    
    $OriginalContent = $Content
    
    foreach ($OldCode in $CodeReplacements.Keys) {
        $NewCode = $CodeReplacements[$OldCode]
        # 替换 wiki-links [[OLD]] 格式
        $Content = $Content -replace "\[\[$([Regex]::Escape($OldCode))\]\]", "[[$NewCode]]"
        # 替换纯文本引用
        $Content = $Content -replace $([Regex]::Escape($OldCode)), $NewCode
    }
    
    if ($Content -ne $OriginalContent) {
        Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline
        $ModifiedFiles++
        Write-Host "  修复: $($File.Name)" -ForegroundColor Yellow
    }
}

Write-Host "`n共修复了 $ModifiedFiles 个文件的内容" -ForegroundColor Green

# ============================================================
# 2. 重命名文件 (仅修改文件名，不改变目录结构)
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
    $Files = Get-ChildItem -Path $ContentPath -Recurse -Filter $Rename.OldName -ErrorAction SilentlyContinue
    foreach ($File in $Files) {
        $NewPath = Join-Path $File.DirectoryName $Rename.NewName
        if ($File.FullName -ne $NewPath) {
            Rename-Item -Path $File.FullName -NewName $Rename.NewName -Force -ErrorAction SilentlyContinue
            Write-Host "  重命名: $($Rename.OldName) -> $($Rename.NewName)" -ForegroundColor Yellow
            $RenamedCount++
        }
    }
}

Write-Host "`n共重命名了 $RenamedCount 个文件" -ForegroundColor Green

Write-Host "`n=== 编码修复完成 ===" -ForegroundColor Green
