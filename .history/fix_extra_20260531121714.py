# -*- coding: utf-8 -*-
import os

BASE_PATH = r"d:\Github\TheMarginalStructure\content\档案"

# Additional rename map for appendix and other files
EXTRA_RENAMES = {
    "IR-V-990-INC-Appendix.1.md": "EVT-P0990-INC-Appendix.1.md",
    "IR-V-990-INC-Appendix.2.md": "EVT-P0990-INC-Appendix.2.md",
    "EL-O881-COG-Appendix.1.md": "EXP-O0881-Appendix.1.md",
    "EL-O881-COG-Appendix.3.md": "EXP-O0881-Appendix.3.md",
    "TF-O-001-TMS - 边际结构.md": "TMS-O0001.md",
    "遗忘图书馆_档案_TMS-R009.md": "TMS-R0009.md",
    "静默车站_档案_TMS-B112.md": "TMS-T0112.md",
}

renamed = 0
for root, dirs, files in os.walk(BASE_PATH):
    for filename in files:
        if filename in EXTRA_RENAMES:
            filepath = os.path.join(root, filename)
            new_name = EXTRA_RENAMES[filename]
            new_path = os.path.join(root, new_name)
            if not os.path.exists(new_path):
                os.rename(filepath, new_path)
                print(f"  [RENAMED] {filename} -> {new_name}")
                renamed += 1
            else:
                print(f"  [SKIP] Target exists: {new_name}")

print(f"\nExtra renames: {renamed} files")
