$BasePath = "d:\Github\TheMarginalStructure\content\档案"

# Fix file content function
function Fix-FileContent {
    param([string]$FilePath, [hashtable]$Replacements)
    
    if (-not (Test-Path $FilePath)) { 
        Write-Host "  [SKIP] File not found: $FilePath" -ForegroundColor Gray
        return 
    }
    
    $Content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    $Original = $Content
    
    foreach ($Key in $Replacements.Keys) {
        $Value = $Replacements[$Key]
        $Content = $Content -replace [regex]::Escape($Key), $Value
    }
    
    if ($Content -ne $Original) {
        Set-Content -Path $FilePath -Value $Content -Encoding UTF8 -NoNewline -Force
        Write-Host "  [FIXED] $(Split-Path $FilePath -Leaf)" -ForegroundColor Yellow
    }
}

# Common replacements for TMS threshold archives
$TMSReplacements = @{
    "TF-L734-LND" = "TMS-L0734"; "TF-L234-LND" = "TMS-L0234"; "TF-O881-COG" = "TMS-O0881"
    "TF-E771-ENT" = "TMS-E0771"; "TF-O442-OBJ" = "TMS-O0442-01"; "TF-O2847-NEG" = "TMS-O2847"
    "TF-L735-LND" = "TMS-L0735"; "TF-T-112-SIL" = "TMS-T0112"; "TF-O-001-TMS" = "TMS-O0001"
    "TMS-L234" = "TMS-L0234"; "TMS-L734" = "TMS-L0734"; "TMS-O881" = "TMS-O0881"
    "TMS-E771" = "TMS-E0771"; "TMS-O442" = "TMS-O0442"; "TMS-L735" = "TMS-L0735"
    "TMS-V990" = "TMS-P0990"; "TMS-T112" = "TMS-T0112"; "TMS-B112" = "TMS-T0112"
    "TMS-R009" = "TMS-R0009"; "TMS-A512" = "TMS-A0512"; "EL-Gamma-L234-COG" = "EXP-L0234"
    "EL-Dreamweaver-O881-COG" = "EXP-O0881"; "EL-Guardian-E771-COG" = "EXP-E0771"
    "EL-Gamma-L734-COG" = "EXP-L0734"; "EL-Beta-O442-SPC" = "EXP-O0442"
    "EL-Gamma-L735-PHY" = "EXP-L0735"; "MHR-L734-PSY-DCarter" = "MED-L0734"
    "MHR-E771-PSY" = "MED-E0771"; "MHR-V990-PSY" = "MED-P0990"; "TD-O881-COG" = "THY-O0881"
    "TD-L234-COG" = "THY-L0234"; "COM-O2847-INT" = "EVT-O2847-COM"
    "IR-V990-INC" = "EVT-P0990-INC"; "HR-MED-DCarter-RES" = "HR-400001"
    "EXP-O442-PHY" = "EXP-O0442"; "PRT-ARC-QRY-COD" = "PRT-0002"
    "PRT-LAB-SAF-SOP" = "PRT-0003"; "PRT-ARC-SOP-ARC" = "PRT-0004"
    "PRT-ARC-RUL-COD" = "PRT-0001"; "PRT-ARC-CLS-THD" = "PRT-0005"
    "TF-V990-TMP" = "TMS-P0990"; "EL-Guardian-B112-TMP" = "EXP-T0112"
    "MHR-B112-TMP" = "MED-T0112"; "IR-B112-TMP" = "EVT-T0112-INC"
    "COM-B112-TMP" = "EVT-T0112-COM"; "TF-T112-SIL" = "TMS-T0112"
    "MHR-GEN-PSY-AKay" = "MED-O0881"; "MHR-L234-COG" = "MED-L0234"
    "TD-L234-MEM" = "THY-L0234"; "EXP-B0112" = "EXP-T0112"
    "HR-ARC-ASharma-RES" = "HR-300002"; "HR-ARC-ASharma" = "HR-300002"
}

Write-Host "=== Fixing Archive Files (PRT-0001 v4.0) ===" -ForegroundColor Green

# Fix TF files in OBJ directory
$OBJPath = Join-Path $BasePath "对象档案 (Object File - OBJ)"
$TMSPath = Join-Path $BasePath "阈界档案 (The Mrginal Structure - TMS)"

# Fix each TF file
$TFFiles = @(
    (Join-Path $OBJPath "囤积者回廊\TF-L734-LND.md"),
    (Join-Path $OBJPath "明知山\TF-L234-LND.md"),
    (Join-Path $OBJPath "万花筒殿\TF-O881-COG.md"),
    (Join-Path $OBJPath "悲鸣之云\TF-E771-ENT.md"),
    (Join-Path $OBJPath "共鸣水晶\TF-O442-OBJ.md"),
    (Join-Path $OBJPath "否定之人\TF-O2847-NEG.md"),
    (Join-Path $OBJPath "深邃之海\TF-L735-LND.md"),
    (Join-Path $OBJPath "静默车站\TF-T-112-SIL.md"),
    (Join-Path $OBJPath "边际结构\TF-O-001-TMS - 边际结构.md"),
    (Join-Path $OBJPath "静默车站\OBJ-B0112.md")
)

Write-Host "`n[1] Fixing TF files content..." -ForegroundColor Cyan
foreach ($f in $TFFiles) { Fix-FileContent $f $TMSReplacements }

# Fix EL files
$ELPath = Join-Path $BasePath "勘探报告 (Exploration Log - EL)"
$ELFiles = @(
    (Join-Path $ELPath "万花筒殿\EL-Dreamweaver-O881-COG.md"),
    (Join-Path $ELPath "明知山\EL-Gamma-L234-COG.md"),
    (Join-Path $ELPath "悲鸣之云\EL-Guardian-E771-COG.md"),
    (Join-Path $ELPath "囤积者回廊\EL-Gamma-L734-COG.md"),
    (Join-Path $ELPath "回音殿堂\EL-Beta-O442-SPC.md"),
    (Join-Path $ELPath "深邃之海\EL-Gamma-L735-PHY.md")
)

Write-Host "`n[2] Fixing EL files content..." -ForegroundColor Cyan
foreach ($f in $ELFiles) { Fix-FileContent $f $TMSReplacements }

# Fix MHR files
$MHRPath = Join-Path $BasePath "医疗报告 (Medical & Health Report - MHR)"
$MHRFiles = @(
    (Join-Path $MHRPath "囤积者回廊\MHR-L734-PSY-DCarter.md"),
    (Join-Path $MHRPath "悲鸣之云\MHR-E771-PSY.md"),
    (Join-Path $MHRPath "永夜钟楼\MHR-V990-PSY.md")
)

Write-Host "`n[3] Fixing MHR files content..." -ForegroundColor Cyan
foreach ($f in $MHRFiles) { Fix-FileContent $f $TMSReplacements }

# Fix TD files
$TDPath = Join-Path $BasePath "理论文件 (Theoretical Document - TD)"
$TDFiles = @(
    (Join-Path $TDPath "万花筒殿\TD-O881-COG.md"),
    (Join-Path $TDPath "明知山\TD-L234-COG.md")
)

Write-Host "`n[4] Fixing TD files content..." -ForegroundColor Cyan
foreach ($f in $TDFiles) { Fix-FileContent $f $TMSReplacements }

# Fix COM files
$COMPath = Join-Path $BasePath "通信记录 (Communication Transcript - COM)"
$COMFiles = @(
    (Join-Path $COMPath "否定之人\COM-O2847-INT.md")
)

Write-Host "`n[5] Fixing COM files content..." -ForegroundColor Cyan
foreach ($f in $COMFiles) { Fix-FileContent $f $TMSReplacements }

# Fix IR files
$IRPath = Join-Path $BasePath "事件报告 (Incident Report - IR)"
$IRFiles = @(
    (Join-Path $IRPath "永夜钟楼\IR-V990-INC.md")
)

Write-Host "`n[6] Fixing IR files content..." -ForegroundColor Cyan
foreach ($f in $IRFiles) { Fix-FileContent $f $TMSReplacements }

# Fix PRT files
$PRTPath = Join-Path $BasePath "协议手册 (Protocol Manual - PRT)"
$PRTFiles = @(
    (Join-Path $PRTPath "代码查询手册 (PRT-ARC-QRY-COD).md"),
    (Join-Path $PRTPath "实验室安全操作规程 (PRT-LAB-SAF-SOP).md"),
    (Join-Path $PRTPath "档案管理规范 (PRT-ARC-SOP-ARC).md"),
    (Join-Path $PRTPath "档案编码规则 (PRT-0001).md"),
    (Join-Path $PRTPath "阈界分类标准 (PRT-ARC-CLS-THD).md")
)

Write-Host "`n[7] Fixing PRT files content..." -ForegroundColor Cyan
foreach ($f in $PRTFiles) { Fix-FileContent $f $TMSReplacements }

# Fix HR files
$HRPath = Join-Path $BasePath "人事档案 (Human Resources - HR)"
$HRFiles = @(
    (Join-Path $HRPath "代维·卡特 (David Carter)\HR-MED-DCarter-RES.md")
)

Write-Host "`n[8] Fixing HR files content..." -ForegroundColor Cyan
foreach ($f in $HRFiles) { Fix-FileContent $f $TMSReplacements }

# Fix EXP files
$EXPPath = Join-Path $BasePath "实验记录 (Experiment Log - EXP)"
$EXPFiles = @(
    (Join-Path $EXPPath "共鸣水晶\EXP-O442-PHY.md")
)

Write-Host "`n[9] Fixing EXP files content..." -ForegroundColor Cyan
foreach ($f in $EXPFiles) { Fix-FileContent $f $TMSReplacements }

# Fix TMS files (update internal references)
$TMSFiles = Get-ChildItem -Path $TMSPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "`n[10] Fixing TMS files content..." -ForegroundColor Cyan
foreach ($f in $TMSFiles) { Fix-FileContent $f.FullName $TMSReplacements }

# Fix other files in archive root
$RootFiles = Get-ChildItem -Path $BasePath -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "`n[11] Fixing root archive files..." -ForegroundColor Cyan
foreach ($f in $RootFiles) { Fix-FileContent $f.FullName $TMSReplacements }

# Rename files
Write-Host "`n[12] Renaming files..." -ForegroundColor Cyan

$RenameOps = @(
    @{Old = (Join-Path $OBJPath "囤积者回廊\TF-L734-LND.md"); New = (Join-Path $OBJPath "囤积者回廊\TMS-L0734.md")}
    @{Old = (Join-Path $OBJPath "明知山\TF-L234-LND.md"); New = (Join-Path $OBJPath "明知山\TMS-L0234.md")}
    @{Old = (Join-Path $OBJPath "万花筒殿\TF-O881-COG.md"); New = (Join-Path $OBJPath "万花筒殿\TMS-O0881.md")}
    @{Old = (Join-Path $OBJPath "悲鸣之云\TF-E771-ENT.md"); New = (Join-Path $OBJPath "悲鸣之云\TMS-E0771.md")}
    @{Old = (Join-Path $OBJPath "共鸣水晶\TF-O442-OBJ.md"); New = (Join-Path $OBJPath "共鸣水晶\TMS-O0442-01.md")}
    @{Old = (Join-Path $OBJPath "否定之人\TF-O2847-NEG.md"); New = (Join-Path $OBJPath "否定之人\TMS-O2847.md")}
    @{Old = (Join-Path $OBJPath "深邃之海\TF-L735-LND.md"); New = (Join-Path $OBJPath "深邃之海\TMS-L0735.md")}
    @{Old = (Join-Path $OBJPath "静默车站\TF-T-112-SIL.md"); New = (Join-Path $OBJPath "静默车站\TMS-T0112.md")}
    @{Old = (Join-Path $ELPath "万花筒殿\EL-Dreamweaver-O881-COG.md"); New = (Join-Path $ELPath "万花筒殿\EXP-O0881.md")}
    @{Old = (Join-Path $ELPath "明知山\EL-Gamma-L234-COG.md"); New = (Join-Path $ELPath "明知山\EXP-L0234.md")}
    @{Old = (Join-Path $ELPath "悲鸣之云\EL-Guardian-E771-COG.md"); New = (Join-Path $ELPath "悲鸣之云\EXP-E0771.md")}
    @{Old = (Join-Path $ELPath "囤积者回廊\EL-Gamma-L734-COG.md"); New = (Join-Path $ELPath "囤积者回廊\EXP-L0734.md")}
    @{Old = (Join-Path $ELPath "回音殿堂\EL-Beta-O442-SPC.md"); New = (Join-Path $ELPath "回音殿堂\EXP-O0442.md")}
    @{Old = (Join-Path $ELPath "深邃之海\EL-Gamma-L735-PHY.md"); New = (Join-Path $ELPath "深邃之海\EXP-L0735.md")}
    @{Old = (Join-Path $MHRPath "囤积者回廊\MHR-L734-PSY-DCarter.md"); New = (Join-Path $MHRPath "囤积者回廊\MED-L0734.md")}
    @{Old = (Join-Path $MHRPath "悲鸣之云\MHR-E771-PSY.md"); New = (Join-Path $MHRPath "悲鸣之云\MED-E0771.md")}
    @{Old = (Join-Path $MHRPath "永夜钟楼\MHR-V990-PSY.md"); New = (Join-Path $MHRPath "永夜钟楼\MED-P0990.md")}
    @{Old = (Join-Path $TDPath "万花筒殿\TD-O881-COG.md"); New = (Join-Path $TDPath "万花筒殿\THY-O0881.md")}
    @{Old = (Join-Path $TDPath "明知山\TD-L234-COG.md"); New = (Join-Path $TDPath "明知山\THY-L0234.md")}
    @{Old = (Join-Path $COMPath "否定之人\COM-O2847-INT.md"); New = (Join-Path $COMPath "否定之人\EVT-O2847-COM.md")}
    @{Old = (Join-Path $IRPath "永夜钟楼\IR-V990-INC.md"); New = (Join-Path $IRPath "永夜钟楼\EVT-P0990-INC.md")}
    @{Old = (Join-Path $HRPath "代维·卡特 (David Carter)\HR-MED-DCarter-RES.md"); New = (Join-Path $HRPath "代维·卡特 (David Carter)\HR-400001.md")}
    @{Old = (Join-Path $EXPPath "共鸣水晶\EXP-O442-PHY.md"); New = (Join-Path $EXPPath "共鸣水晶\EXP-O0442.md")}
)

$RenamedCount = 0
foreach ($op in $RenameOps) {
    if (Test-Path $op.Old) {
        Rename-Item -Path $op.Old -NewName (Split-Path $op.New -Leaf) -Force -ErrorAction SilentlyContinue
        Write-Host "  [RENAMED] $(Split-Path $op.Old -Leaf) -> $(Split-Path $op.New -Leaf)" -ForegroundColor Yellow
        $RenamedCount++
    }
}

# Rename PRT files
$PRTRenameOps = @(
    @{Old = (Join-Path $PRTPath "代码查询手册 (PRT-ARC-QRY-COD).md"); New = "PRT-0002.md"},
    @{Old = (Join-Path $PRTPath "实验室安全操作规程 (PRT-LAB-SAF-SOP).md"); New = "PRT-0003.md"},
    @{Old = (Join-Path $PRTPath "档案管理规范 (PRT-ARC-SOP-ARC).md"); New = "PRT-0004.md"},
    @{Old = (Join-Path $PRTPath "档案编码规则 (PRT-0001).md"); New = "PRT-0001.md"},
    @{Old = (Join-Path $PRTPath "阈界分类标准 (PRT-ARC-CLS-THD).md"); New = "PRT-0005.md"}
)

foreach ($op in $PRTRenameOps) {
    if (Test-Path $op.Old) {
        Rename-Item -Path $op.Old -NewName $op.New -Force -ErrorAction SilentlyContinue
        Write-Host "  [RENAMED] $(Split-Path $op.Old -Leaf) -> $($op.New)" -ForegroundColor Yellow
        $RenamedCount++
    }
}

Write-Host "`n=== Fix Complete ===" -ForegroundColor Green
Write-Host "Renamed: $RenamedCount files" -ForegroundColor Green
