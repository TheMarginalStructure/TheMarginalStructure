# The Marginal Structure — 边际结构

> 本项目工作区，包含三个 Git 子模块。

## 仓库结构

```
TheMarginalStructure/         ← 父工作区（此仓库）
├── content/                   ← 世界观设定、档案、系列等文本内容
│                              → git@tms:TheMarginalStructure/ThresholdArchive.git
├── frontend/                  ← 前端应用 (React + Vite + Tailwind)
│                              → git@tms:TheMarginalStructure/ThresholdArchive-Frontend.git
├── backend/                   ← 后端 API (Express + Prisma + TypeScript)
│                              → git@tms:TheMarginalStructure/ThresholdArchive-Backend.git
├── start.ps1                  ← 一键启动脚本
└── README.md
```

## 快速开始

```powershell
# 克隆（含子模块）
git clone --recurse-submodules git@tms:TheMarginalStructure/ThresholdArchive.git TheMarginalStructure

# 如果已克隆，初始化子模块
git submodule update --init --recursive

# 启动前后端服务
./start.ps1
```

## 子模块更新

```powershell
# 拉取所有子模块最新代码
git submodule update --remote --merge

# 或逐个仓库操作
cd content && git pull
cd ../frontend && git pull
cd ../backend && git pull
```

## 单独仓库地址

| 子模块 | GitHub |
|--------|--------|
| 内容 | [ThresholdArchive](https://github.com/TheMarginalStructure/ThresholdArchive) |
| 前端 | [ThresholdArchive-Frontend](https://github.com/TheMarginalStructure/ThresholdArchive-Frontend) |
| 后端 | [ThresholdArchive-Backend](https://github.com/TheMarginalStructure/ThresholdArchive-Backend) |
