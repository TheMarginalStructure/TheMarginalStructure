# Archive Code Fix Script v2.0 - Based on PRT-0001 v4.0
$ErrorActionPreference = "Continue"
$ContentPath = "d:\Github\TheMarginalStructure\content\档案"

Write-Host "=== Starting Archive Code Fix (PRT-0001 v4.0) ===" -ForegroundColor Green

# Step 1: Fix code references in file contents
Write-Host "`n[Step 1] Fixing code references in file contents..." -ForegroundColor Cyan

$CodeReplacements = [ordered]@{
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
    "EL-Gamma-L234-COG" = "EXP-L0234"
    "EL-Dreamweaver-O881-COG" = "EXP-O0881"
    "EL-Guardian-E771-COG" = "EXP-E0771"
    "EL-Gamma-L734-COG" = "EXP-L0734"
    "EL-Beta-O442-SPC" = "EXP-O0442"
    "EL-Gamma-L735-PHY" = "EXP-L0735"
    "EL-Guardian-B112-TMP" = "EXP-T0112"
    "MHR-L734-PSY-DCarter" = "MED-L0734"
    "MHR-E771-PSY" = "MED-E0771"
    "MHR-V990-PSY" = "MED-P0990"
    "MHR-GEN-PSY-AKay" = "MED-O0881"
    "MHR-L234-COG" = "MED-L0234"
    "MHR-B112-TMP" = "MED-T0112"
    "TD-O881-COG" = "THY-O0881"
    "TD-L234-COG" = "THY-L0234"
    "TD-L234-MEM" = "THY-L0234"
    "COM-O2847-INT" = "EVT-O2847-COM"
    "COM-B112-TMP" = "EVT-T0112-COM"
    "COM-L234-INT" = "EVT-L0234-COM"
    "IR-V990-INC" = "EVT-P0990-INC"
    "IR-V-990-INC" = "EVT-P0990-INC"
    "IR-B112-TMP" = "EVT-T0112-INC"
    "IR-L234-COG" = "EVT-L0234-INC"
    "PRT-ARC-QRY-COD" = "PRT-0002"
    "PRT-LAB-SAF-SOP" = "PRT-0003"
    "PRT-ARC-SOP-ARC" = "PRT-0004"
    "PRT-ARC-RUL-COD" = "PRT-0001"
    "PRT-ARC-CLS-THD" = "PRT-0005"
    "PRT-ARC-SOP" = "PRT-0004"
    "PRT-LAB-SOP-SAF" = "PRT-0003"
    "HR-MED-DCarter-RES" = "HR-400001"
    "HR-ARC-ASharma-RES" = "HR-300002"
    "HR-ARC-ASharma" = "HR-300002"
    "EXP-O442-PHY" = "EXP-O0442"
    "EXP-A512-BIO" = "EXP-A0512"
    "EXP-B0112" = "EXP-T0112"
    "TMS-L234" = "TMS-L0234"
    "TMS-L734" = "TMS-L0734"
    "TMS-O881" = "TMS-O0881"
    "TMS-E771" = "TMS-E0771"
    "TMS-O442" = "TMS-O0442"
    "TMS-L735" = "TMS-L0735"
    "TMS-V990" = "TMS-P0990"
    "TMS-T112" = "TMS-T0112"
    "TMS-B112" = "TMS-T0112"
    "TMS-R009" = "TMS-R0009"
    "TMS-A512" = "TMS-A0512"
}

$AllMdFiles = Get-ChildItem -Path $ContentPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue
$ModifiedFiles = 0

foreach ($File in $AllMdFiles) {
    try {
        $Content = Get-Content -Path $File.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        if ($null -eq $Content) { continue }
        
        $OriginalContent = $Content
        
        foreach ($OldCode in $CodeReplacements.Keys) {
            $NewCode = $CodeReplacements[$OldCode]
            $Content = $Content -replace "\[\[$([regex]::Escape($OldCode))\]\]", "[[$NewCode]]"
            $Content = $Content -replace [regex]::Escape($OldCode), $NewCode
        }
        
        if ($Content -ne $OriginalContent) {
            Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline -Force
            $ModifiedFiles++
            Write-Host "  [FIXED] $($File.Name)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "  [ERROR] Processing $($File.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nFixed content in $ModifiedFiles files" -ForegroundColor Green

# Step 2: Rename files
Write-Host "`n[Step 2] Renaming files..." -ForegroundColor Cyan

$FileRenames = @(
    @{Old = "TF-L734-LND.md"; New = "TMS-L0734.md"},
    @{Old = "TF-L234-LND.md"; New = "TMS-L0234.md"},
    @{Old = "TF-O881-COG.md"; New = "TMS-O0881.md"},
    @{Old = "TF-E771-ENT.md"; New = "TMS-E0771.md"},
    @{Old = "TF-O442-OBJ.md"; New = "TMS-O0442-01.md"},
    @{Old = "TF-O2847-NEG.md"; New = "TMS-O2847.md"},
    @{Old = "TF-L735-LND.md"; New = "TMS-L0735.md"},
    @{Old = "TF-T-112-SIL.md"; New = "TMS-T0112.md"},
    @{Old = "EL-Dreamweaver-O881-COG.md"; New = "EXP-O0881.md"},
    @{Old = "EL-Gamma-L234-COG.md"; New = "EXP-L0234.md"},
    @{Old = "EL-Guardian-E771-COG.md"; New = "EXP-E0771.md"},
    @{Old = "EL-Gamma-L734-COG.md"; New = "EXP-L0734.md"},
    @{Old = "EL-Beta-O442-SPC.md"; New = "EXP-O0442.md"},
    @{Old = "EL-Gamma-L735-PHY.md"; New = "EXP-L0735.md"},
    @{Old = "MHR-L734-PSY-DCarter.md"; New = "MED-L0734.md"},
    @{Old = "MHR-E771-PSY.md"; New = "MED-E0771.md"},
    @{Old = "MHR-V990-PSY.md"; New = "MED-P0990.md"},
    @{Old = "TD-O881-COG.md"; New = "THY-O0881.md"},
    @{Old = "TD-L234-COG.md"; New = "THY-L0234.md"},
    @{Old = "COM-O2847-INT.md"; New = "EVT-O2847-COM.md"},
    @{Old = "IR-V990-INC.md"; New = "EVT-P0990-INC.md"},
    @{Old = "HR-MED-DCarter-RES.md"; New = "HR-400001.md"},
    @{Old = "EXP-O442-PHY.md"; New = "EXP-O0442.md"}
)

$PRTFileRenames = @(
    @{Old = "代码查询手册 (PRT-ARC-QRY-COD).md"; New = "PRT-0002.md"},
    @{Old = "实验室安全操作规程 (PRT-LAB-SAF-SOP).md"; New = "PRT-0003.md"},
    @{Old = "档案管理规范 (PRT-ARC-SOP-ARC).md"; New = "PRT-0004.md"},
    @{Old = "档案编码规则 (PRT-0001).md"; New = "PRT-0001.md"},
    @{Old = "阈界分类标准 (PRT-ARC-CLS-THD).md"; New = "PRT-0005.md"}
)

$RenamedCount = 0

foreach ($Rename in $FileRenames) {
    try {
        $Files = Get-ChildItem -Path $ContentPath -Recurse -Filter $Rename.Old -ErrorAction SilentlyContinue
        foreach ($File in $Files) {
            $NewPath = Join-Path $File.DirectoryName $Rename.New
            if ($File.FullName -ne $NewPath) {
                Rename-Item -Path $File.FullName -NewName $Rename.New -Force -ErrorAction Stop
                Write-Host "  [RENAMED] $($Rename.Old) -> $($Rename.New)" -ForegroundColor Yellow
                $RenamedCount++
            }
        }
    }
    catch {
        Write-Host "  [ERROR] Renaming $($Rename.Old): $_" -ForegroundColor Red
    }
}

foreach ($Rename in $PRTFileRenames) {
    try {
        $PRTPath = Join-Path $ContentPath "协议手册 (Protocol Manual - PRT)"
        $Files = Get-ChildItem -Path $PRTPath -Filter $Rename.Old -ErrorAction SilentlyContinue
        foreach ($File in $Files) {
            $NewPath = Join-Path $File.DirectoryName $Rename.New
            if ($File.FullName -ne $NewPath) {
                Rename-Item -Path $File.FullName -NewName $Rename.New -Force -ErrorAction Stop
                Write-Host "  [RENAMED] $($Rename.Old) -> $($Rename.New)" -ForegroundColor Yellow
                $RenamedCount++
            }
        }
    }
    catch {
        Write-Host "  [ERROR] Renaming $($Rename.Old): $_" -ForegroundColor Red
    }
}

Write-Host "`nRenamed $RenamedCount files" -ForegroundColor Green

# Step 3: Fix PRT-0001 metadata
Write-Host "`n[Step 3] Fixing PRT-0001 metadata..." -ForegroundColor Cyan

$PRT0001Path = Join-Path $ContentPath "协议手册 (Protocol Manual - PRT)\PRT-0001.md"
if (Test-Path $PRT0001Path) {
    $Content = Get-Content -Path $PRT0001Path -Raw -Encoding UTF8
    $Content = $Content -replace "文档编码：PRT-ARC-RUL-COD", "文档编码：PRT-0001"
    Set-Content -Path $PRT0001Path -Value $Content -Encoding UTF8 -NoNewline -Force
    Write-Host "  [FIXED] PRT-0001.md metadata" -ForegroundColor Yellow
}

Write-Host "`n=== Code Fix Complete ===" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - Content fixes: $ModifiedFiles files" -ForegroundColor Green
Write-Host "  - File renames: $RenamedCount files" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Review fixed files" -ForegroundColor White
Write-Host "  2. Verify wiki-links" -ForegroundColor White
Write-Host "  3. Run git status" -ForegroundColor White
Write-Host "  4. Commit changes if correct" -ForegroundColor White
