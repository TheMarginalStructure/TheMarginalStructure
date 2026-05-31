# 档案编码修复脚本
# 根据 PRT-0001 v4.0 编码规则修复所有档案文件编码

# 设置工作目录
$ContentPath = "d:\Github\TheMarginalStructure\content\档案"

# 定义文件重命名和编码映射关系
$FileMappings = @(
    # 对象档案 (TF → TMS/OBJ)
    @{OldName = "TF-L734-LND.md"; NewName = "TMS-L0734.md"; OldCode = "TF-L734-LND"; NewCode = "TMS-L0734"},
    @{OldName = "TF-L234-LND.md"; NewName = "TMS-L0234.md"; OldCode = "TF-L234-LND"; NewCode = "TMS-L0234"},
    @{OldName = "TF-O881-COG.md"; NewName = "TMS-O0881.md"; OldCode = "TF-O881-COG"; NewCode = "TMS-O0881"},
    @{OldName = "TF-E771-ENT.md"; NewName = "TMS-E0771.md"; OldCode = "TF-E771-ENT"; NewCode = "TMS-E0771"},
    @{OldName = "TF-O442-OBJ.md"; NewName = "TMS-O0442-01.md"; OldCode = "TF-O442-OBJ"; NewCode = "TMS-O0442-01"},
    @{OldName = "TF-O2847-NEG.md"; NewName = "TMS-O2847.md"; OldCode = "TF-O2847-NEG"; NewCode = "TMS-O2847"},
    @{OldName = "TF-L735-LND.md"; NewName = "TMS-L0735.md"; OldCode = "TF-L735-LND"; NewCode = "TMS-L0735"},
    
    # 勘探报告 (EL → EXP)
    @{OldName = "EL-Dreamweaver-O881-COG.md"; NewName = "EXP-O0881.md"; OldCode = "EL-Dreamweaver-O881-COG"; NewCode = "EXP-O0881"},
    @{OldName = "EL-Gamma-L234-COG.md"; NewName = "EXP-L0234.md"; OldCode = "EL-Gamma-L234-COG"; NewCode = "EXP-L0234"},
    @{OldName = "EL-Guardian-E771-COG.md"; NewName = "EXP-E0771.md"; OldCode = "EL-Guardian-E771-COG"; NewCode = "EXP-E0771"},
    @{OldName = "EL-Gamma-L734-COG.md"; NewName = "EXP-L0734.md"; OldCode = "EL-Gamma-L734-COG"; NewCode = "EXP-L0734"},
    @{OldName = "EL-Beta-O442-SPC.md"; NewName = "EXP-O0442.md"; OldCode = "EL-Beta-O442-SPC"; NewCode = "EXP-O0442"},
    @{OldName = "EL-Gamma-L735-PHY.md"; NewName = "EXP-L0735.md"; OldCode = "EL-Gamma-L735-PHY"; NewCode = "EXP-L0735"},
    
    # 医疗报告 (MHR → MED)
    @{OldName = "MHR-L734-PSY-DCarter.md"; NewName = "MED-L0734.md"; OldCode = "MHR-L734-PSY-DCarter"; NewCode = "MED-L0734"},
    @{OldName = "MHR-E771-PSY.md"; NewName = "MED-E0771.md"; OldCode = "MHR-E771-PSY"; NewCode = "MED-E0771"},
    @{OldName = "MHR-V990-PSY.md"; NewName = "MED-P0990.md"; OldCode = "MHR-V990-PSY"; NewCode = "MED-P0990"},
    
    # 理论文件 (TD → THY)
    @{OldName = "TD-O881-COG.md"; NewName = "THY-O0881.md"; OldCode = "TD-O881-COG"; NewCode = "THY-O0881"},
    @{OldName = "TD-L234-COG.md"; NewName = "THY-L0234.md"; OldCode = "TD-L234-COG"; NewCode = "THY-L0234"},
    
    # 通信记录 (COM → EVT)
    @{OldName = "COM-O2847-INT.md"; NewName = "EVT-O2847-COM.md"; OldCode = "COM-O2847-INT"; NewCode = "EVT-O2847-COM"},
    
    # 事件报告 (IR → EVT)
    @{OldName = "IR-V990-INC.md"; NewName = "EVT-P0990-INC.md"; OldCode = "IR-V990-INC"; NewCode = "EVT-P0990-INC"},
    
    # 协议手册 (PRT)
    @{OldName = "代码查询手册 (PRT-ARC-QRY-COD).md"; NewName = "PRT-0002.md"; OldCode = "PRT-ARC-QRY-COD"; NewCode = "PRT-0002"},
    @{OldName = "实验室安全操作规程 (PRT-LAB-SAF-SOP).md"; NewName = "PRT-0003.md"; OldCode = "PRT-LAB-SAF-SOP"; NewCode = "PRT-0003"},
    @{OldName = "档案管理规范 (PRT-ARC-SOP-ARC).md"; NewName = "PRT-0004.md"; OldCode = "PRT-ARC-SOP-ARC"; NewCode = "PRT-0004"},
    @{OldName = "档案编码规则 (PRT-0001).md"; NewName = "PRT-0001.md"; OldCode = "PRT-ARC-RUL-COD"; NewCode = "PRT-0001"},
    @{OldName = "阈界分类标准 (PRT-ARC-CLS-THD).md"; NewName = "PRT-0005.md"; OldCode = "PRT-ARC-CLS-THD"; NewCode = "PRT-0005"},
    
    # 人事档案 (HR)
    @{OldName = "HR-MED-DCarter-RES.md"; NewName = "HR-400001.md"; OldCode = "HR-MED-DCarter-RES"; NewCode = "HR-400001"},
    
    # 实验记录 (EXP)
    @{OldName = "EXP-O442-PHY.md"; NewName = "EXP-O0442.md"; OldCode = "EXP-O442-PHY"; NewCode = "EXP-O0442"}
)

Write-Host "开始档案编码修复..." -ForegroundColor Green

# 查找所有需要修复的文件
$FoundFiles = @()
foreach ($mapping in $FileMappings) {
    $Files = Get-ChildItem -Path $ContentPath -Recurse -Filter $mapping.OldName -ErrorAction SilentlyContinue
    foreach ($File in $Files) {
        $FoundFiles += @{
            File = $File
            Mapping = $mapping
        }
    }
}

Write-Host "找到 $($FoundFiles.Count) 个需要修复的文件" -ForegroundColor Yellow

# 显示找到的文件
foreach ($found in $FoundFiles) {
    Write-Host "  $($found.File.FullName) -> $($found.Mapping.NewCode)" -ForegroundColor Cyan
}
