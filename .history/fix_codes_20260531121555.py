# -*- coding: utf-8 -*-
import os
import re

BASE_PATH = r"d:\Github\TheMarginalStructure\content\档案"

# Code replacement map (order matters - longer patterns first)
REPLACEMENTS = [
    ("TF-L734-LND", "TMS-L0734"),
    ("TF-L234-LND", "TMS-L0234"),
    ("TF-O881-COG", "TMS-O0881"),
    ("TF-E771-ENT", "TMS-E0771"),
    ("TF-O442-OBJ", "TMS-O0442-01"),
    ("TF-O442-TMS", "TMS-O0442-01"),
    ("TF-O2847-NEG", "TMS-O2847"),
    ("TF-L735-LND", "TMS-L0735"),
    ("TF-T-112-SIL", "TMS-T0112"),
    ("TF-T112-SIL", "TMS-T0112"),
    ("TF-V990-TMP", "TMS-P0990"),
    ("TF-O-001-TMS", "TMS-O0001"),
    ("EL-Gamma-L234-COG", "EXP-L0234"),
    ("EL-Dreamweaver-O881-COG", "EXP-O0881"),
    ("EL-Guardian-E771-COG", "EXP-E0771"),
    ("EL-Gamma-L734-COG", "EXP-L0734"),
    ("EL-Beta-O442-SPC", "EXP-O0442"),
    ("EL-Gamma-L735-PHY", "EXP-L0735"),
    ("EL-Guardian-B112-TMP", "EXP-T0112"),
    ("MHR-L734-PSY-DCarter", "MED-L0734"),
    ("MHR-E771-PSY", "MED-E0771"),
    ("MHR-V990-PSY", "MED-P0990"),
    ("MHR-GEN-PSY-AKay", "MED-O0881"),
    ("MHR-L234-COG", "MED-L0234"),
    ("MHR-B112-TMP", "MED-T0112"),
    ("TD-O881-COG", "THY-O0881"),
    ("TD-L234-COG", "THY-L0234"),
    ("TD-L234-MEM", "THY-L0234"),
    ("COM-O2847-INT", "EVT-O2847-COM"),
    ("COM-B112-TMP", "EVT-T0112-COM"),
    ("COM-L234-INT", "EVT-L0234-COM"),
    ("IR-V990-INC", "EVT-P0990-INC"),
    ("IR-V-990-INC", "EVT-P0990-INC"),
    ("IR-B112-TMP", "EVT-T0112-INC"),
    ("IR-L234-COG", "EVT-L0234-INC"),
    ("PRT-ARC-QRY-COD", "PRT-0002"),
    ("PRT-LAB-SAF-SOP", "PRT-0003"),
    ("PRT-ARC-SOP-ARC", "PRT-0004"),
    ("PRT-ARC-RUL-COD", "PRT-0001"),
    ("PRT-ARC-CLS-THD", "PRT-0005"),
    ("PRT-ARC-SOP", "PRT-0004"),
    ("PRT-LAB-SOP-SAF", "PRT-0003"),
    ("HR-MED-DCarter-RES", "HR-400001"),
    ("HR-ARC-ASharma-RES", "HR-300002"),
    ("HR-ARC-ASharma", "HR-300002"),
    ("EXP-O442-PHY", "EXP-O0442"),
    ("EXP-A512-BIO", "EXP-A0512"),
    ("EXP-B0112", "EXP-T0112"),
    ("TMS-L234", "TMS-L0234"),
    ("TMS-L734", "TMS-L0734"),
    ("TMS-O881", "TMS-O0881"),
    ("TMS-E771", "TMS-E0771"),
    ("TMS-O442", "TMS-O0442"),
    ("TMS-L735", "TMS-L0735"),
    ("TMS-V990", "TMS-P0990"),
    ("TMS-T112", "TMS-T0112"),
    ("TMS-B112", "TMS-T0112"),
    ("TMS-R009", "TMS-R0009"),
    ("TMS-A512", "TMS-A0512"),
]

# File rename map: old_filename -> new_filename
RENAME_MAP = {
    "TF-L734-LND.md": "TMS-L0734.md",
    "TF-L234-LND.md": "TMS-L0234.md",
    "TF-O881-COG.md": "TMS-O0881.md",
    "TF-E771-ENT.md": "TMS-E0771.md",
    "TF-O442-OBJ.md": "TMS-O0442-01.md",
    "TF-O2847-NEG.md": "TMS-O2847.md",
    "TF-L735-LND.md": "TMS-L0735.md",
    "TF-T-112-SIL.md": "TMS-T0112.md",
    "EL-Dreamweaver-O881-COG.md": "EXP-O0881.md",
    "EL-Gamma-L234-COG.md": "EXP-L0234.md",
    "EL-Guardian-E771-COG.md": "EXP-E0771.md",
    "EL-Gamma-L734-COG.md": "EXP-L0734.md",
    "EL-Beta-O442-SPC.md": "EXP-O0442.md",
    "EL-Gamma-L735-PHY.md": "EXP-L0735.md",
    "MHR-L734-PSY-DCarter.md": "MED-L0734.md",
    "MHR-E771-PSY.md": "MED-E0771.md",
    "MHR-V990-PSY.md": "MED-P0990.md",
    "TD-O881-COG.md": "THY-O0881.md",
    "TD-L234-COG.md": "THY-L0234.md",
    "COM-O2847-INT.md": "EVT-O2847-COM.md",
    "IR-V990-INC.md": "EVT-P0990-INC.md",
    "HR-MED-DCarter-RES.md": "HR-400001.md",
    "EXP-O442-PHY.md": "EXP-O0442.md",
    "代码查询手册 (PRT-ARC-QRY-COD).md": "PRT-0002.md",
    "实验室安全操作规程 (PRT-LAB-SAF-SOP).md": "PRT-0003.md",
    "档案管理规范 (PRT-ARC-SOP-ARC).md": "PRT-0004.md",
    "档案编码规则 (PRT-0001).md": "PRT-0001.md",
    "阈界分类标准 (PRT-ARC-CLS-THD).md": "PRT-0005.md",
}

def fix_content(filepath):
    """Fix code references in a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"  [ERROR] Reading {os.path.basename(filepath)}: {e}")
        return False
    
    original = content
    for old_code, new_code in REPLACEMENTS:
        content = content.replace(old_code, new_code)
    
    if content != original:
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"  [FIXED] {os.path.basename(filepath)}")
            return True
        except Exception as e:
            print(f"  [ERROR] Writing {os.path.basename(filepath)}: {e}")
            return False
    return False

def rename_file(filepath, new_name):
    """Rename a file"""
    try:
        new_path = os.path.join(os.path.dirname(filepath), new_name)
        if os.path.exists(new_path):
            print(f"  [SKIP] Target exists: {new_name}")
            return False
        os.rename(filepath, new_path)
        print(f"  [RENAMED] {os.path.basename(filepath)} -> {new_name}")
        return True
    except Exception as e:
        print(f"  [ERROR] Renaming {os.path.basename(filepath)}: {e}")
        return False

def walk_directory(base_path):
    """Walk directory tree and process all markdown files"""
    fixed_count = 0
    rename_count = 0
    
    for root, dirs, files in os.walk(base_path):
        for filename in files:
            if filename.endswith('.md'):
                filepath = os.path.join(root, filename)
                if fix_content(filepath):
                    fixed_count += 1
    
    # Second pass: rename files
    for root, dirs, files in os.walk(base_path):
        for filename in files:
            if filename in RENAME_MAP:
                filepath = os.path.join(root, filename)
                if rename_file(filepath, RENAME_MAP[filename]):
                    rename_count += 1
    
    return fixed_count, rename_count

if __name__ == '__main__':
    print("=== Starting Archive Code Fix (PRT-0001 v4.0) ===")
    print(f"Base path: {BASE_PATH}")
    
    if not os.path.exists(BASE_PATH):
        print(f"ERROR: Path not found: {BASE_PATH}")
        exit(1)
    
    fixed, renamed = walk_directory(BASE_PATH)
    
    print(f"\n=== Fix Complete ===")
    print(f"Content fixes: {fixed} files")
    print(f"File renames: {renamed} files")
