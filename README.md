# Mac Multi-User Setup

自动化配置脚本，用于在 Mac mini 上为多个用户快速部署 Claude Code 开发环境。

## 功能特性

- ✅ 一键创建新用户账户
- ✅ 自动安装和配置 Homebrew
- ✅ 配置 Tmux 终端复用器
- ✅ 安装 Oh My Zsh + Powerlevel10k 主题
- ✅ 集成自动补全和语法高亮插件
- ✅ 自动安装 Claude Code
- ✅ 预配置常用开发别名
- ✅ 支持多用户同时运行 Claude Code

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/your-username/mac-multi-user-setup.git
cd mac-multi-user-setup
```

### 2. 创建新用户

```bash
# 基本用法（不配置 API key）
sudo ./scripts/create-user.sh username

# 带 API key（推荐）
sudo ./scripts/create-user.sh username sk-ant-xxxxx
```

### 3. 用户登录

```bash
su - username
```

## 包含的配置

### Zsh 插件
- `zsh-autosuggestions` - 命令自动建议
- `zsh-syntax-highlighting` - 语法高亮
- `zsh-completions` - 增强的自动补全
- `git`, `docker`, `kubectl`, `npm` 等工具插件

### 预配置别名

#### Claude Code
- `cc` - 启动 Claude Code
- `ccc` - 继续上次会话
- `ccr` - 重置会话

#### Tmux
- `ta <session>` - 附加到会话
- `tl` - 列出所有会话
- `tn <name>` - 创建新会话

#### Git
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - 图形化日志

### Tmux 配置
- 前缀键：`Ctrl-a`（替代默认的 Ctrl-b）
- 鼠标支持已启用
- 分屏快捷键：`|` 水平分屏，`-` 垂直分屏
- Alt + 方向键切换面板

## 多用户并发

每个用户可以独立运行自己的 Claude Code 实例：

```bash
# 用户 A
tmux new -s claude-a
claude

# 用户 B
tmux new -s claude-b
claude

# 用户 C
tmux new -s claude-c
claude
```

所有实例可以同时在后台运行，互不干扰。

## 目录结构

```
mac-multi-user-setup/
├── README.md
├── scripts/
│   └── create-user.sh       # 主安装脚本
├── templates/
│   ├── .zshrc              # Zsh 配置模板
│   └── .tmux.conf          # Tmux 配置模板
└── docs/
    └── troubleshooting.md  # 故障排除指南
```

## 系统要求

- macOS 12.0 或更高版本
- 管理员权限（sudo）
- 互联网连接

## 手动配置 API Key

如果创建用户时未提供 API key，用户可以稍后配置：

```bash
claude config
# 按提示输入 API key
```

## 更新配置

要更新现有用户的配置：

```bash
# 拉取最新配置
git pull

# 重新应用配置文件
cp templates/.zshrc ~/.zshrc
cp templates/.tmux.conf ~/.tmux.conf
source ~/.zshrc
```

## 故障排除

### Homebrew 安装失败
```bash
# 手动安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Oh My Zsh 插件未加载
```bash
# 重新加载配置
source ~/.zshrc
```

### Claude Code 未找到
```bash
# 手动安装
brew install claude
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
