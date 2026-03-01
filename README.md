<div align="center">

# 🚀 Mac Multi-User Claude Code Setup

**一键部署多用户 Claude Code 开发环境**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

[快速开始](#-快速开始) • [功能特性](#-功能特性) • [文档](#-文档) • [示例](#-使用示例)

</div>

---

## 📖 简介

Mac Multi-User Setup 是一个自动化配置工具，专为在 Mac mini 上托管多用户 Claude Code 环境而设计。通过一条命令，即可为新用户创建完整的开发环境，包括终端美化、工具配置和远程访问。

### 🎯 适用场景

- 🏢 **团队协作** - 在一台 Mac mini 上为整个团队提供 Claude Code 访问
- 🎓 **教育培训** - 为学生快速部署统一的开发环境
- 💼 **远程工作** - 支持从任何地方通过 SSH 访问
- 🔬 **实验环境** - 为不同项目创建隔离的用户环境

---

## ✨ 功能特性

<table>
<tr>
<td width="50%">

### 🎨 终端美化
- **Powerlevel10k** 主题
- **自动补全** 和 **语法高亮**
- **Tmux** 终端复用器
- 预配置常用别名

</td>
<td width="50%">

### 🔧 自动化配置
- 一键创建用户
- 自动安装 Homebrew
- 自动配置 Claude Code
- 批量用户创建支持

</td>
</tr>
<tr>
<td width="50%">

### 🌐 远程访问
- SSH 服务器配置
- 端口转发支持
- DDNS 和 Tailscale 集成
- 安全最佳实践

</td>
<td width="50%">

### 👥 多用户支持
- 独立用户空间
- 并发运行支持
- 资源隔离
- 独立 API key 管理

</td>
</tr>
</table>

---

## 🚀 快速开始

### 前置要求

- macOS 12.0 或更高版本
- 管理员权限（sudo）
- 互联网连接

### 安装

```bash
# 克隆仓库
git clone https://github.com/your-username/mac-multi-user-setup.git
cd mac-multi-user-setup
```

### 创建第一个用户

```bash
# 使用简化脚本（推荐）
sudo ./scripts/quick-create-user.sh alice

# 或指定密码和 API key
sudo ./scripts/quick-create-user.sh alice mypassword sk-ant-api03-xxxxx
```

### 用户登录

```bash
# 本地登录
ssh alice@localhost

# 远程登录（需先配置 SSH）
ssh alice@your-server-ip
```

### 启动 Claude Code

```bash
# 创建 tmux 会话
tmux new -s main

# 启动 Claude Code
claude

# 分离会话（Ctrl-a d）
# Claude 将在后台继续运行
```

---

## 📚 使用示例

### 场景 1：为团队创建多个用户

```bash
# 创建团队成员账户
sudo ./scripts/quick-create-user.sh alice alice2026 sk-ant-key1
sudo ./scripts/quick-create-user.sh bob bob2026 sk-ant-key2
sudo ./scripts/quick-create-user.sh charlie charlie2026 sk-ant-key3

# 查看所有用户
dscl . list /Users | grep -v "^_"
```

### 场景 2：配置远程访问

```bash
# 启用 SSH 服务
sudo ./scripts/setup-ssh-access.sh

# 配置路由器端口转发
# 外部端口: 2222 → 内部端口: 22

# 从外网连接
ssh -p 2222 alice@your-public-ip
```

### 场景 3：批量创建用户

```bash
# 创建用户列表文件
cat > users.txt << EOF
alice:pass123:sk-ant-key1
bob:pass456:sk-ant-key2
charlie:pass789:sk-ant-key3
EOF

# 批量创建
while IFS=: read -r user pass key; do
    sudo ./scripts/quick-create-user.sh "$user" "$pass" "$key"
done < users.txt
```

---

## 🏗️ 项目结构

```
mac-multi-user-setup/
├── 📄 README.md                    # 项目文档
├── 📄 快速开始.md                   # 快速参考
├── 📄 新用户使用指南.md              # 用户手册
├── 📄 管理员快速参考.md              # 管理员手册
│
├── 📁 scripts/                     # 脚本目录
│   ├── quick-create-user.sh       # 快速创建用户
│   ├── create-user.sh             # 完整创建脚本
│   ├── batch-create-users.sh      # 批量创建
│   ├── setup-ssh-access.sh        # SSH 配置
│   └── setup-user-ssh-keys.sh     # SSH 密钥管理
│
├── 📁 templates/                   # 配置模板
│   ├── .zshrc                     # Zsh 配置
│   └── .tmux.conf                 # Tmux 配置
│
└── 📁 docs/                        # 详细文档
    ├── quick-start.md             # 快速开始
    ├── remote-access.md           # 远程访问指南
    ├── remote-access-quick-ref.md # 远程访问速查
    ├── troubleshooting.md         # 故障排除
    └── github-setup.md            # GitHub 部署
```

---

## 🎨 终端效果

用户登录后将获得：

- ✨ **美观的 Powerlevel10k 主题**
- 🔍 **智能命令补全**（输入时显示灰色建议）
- 🌈 **语法高亮**（命令正确显示绿色，错误显示红色）
- ⚡ **快捷别名**（`cc` 启动 Claude，`ta` 连接 tmux）
- 📦 **Tmux 会话管理**（保持工作持久化）

---

## 📊 性能指标

### 并发能力

| Mac mini 配置 | 推荐并发用户数 | 内存占用/用户 |
|--------------|--------------|-------------|
| 8GB RAM      | 2-3 用户     | ~2-3GB      |
| 16GB RAM     | 4-5 用户     | ~2-3GB      |
| 32GB RAM     | 8-10 用户    | ~2-3GB      |

### 创建用户耗时

- 基础用户创建：~5 秒
- 完整环境配置：~2-3 分钟（首次安装 Homebrew）
- 后续用户创建：~10 秒

---

## 🔒 安全特性

- 🔐 **SSH 密钥认证** - 支持无密码登录
- 🚫 **禁用 root 登录** - 防止暴力破解
- 🔥 **防火墙配置** - 自动添加 SSH 例外
- 👤 **用户隔离** - 独立的用户空间和权限
- 📝 **日志审计** - 完整的登录日志记录
- 🔑 **独立 API key** - 每个用户使用独立凭证

---

## 📖 文档

### 用户文档
- [新用户使用指南](新用户使用指南.md) - 给新用户的完整说明
- [快速开始](快速开始.md) - 最简洁的快速参考

### 管理员文档
- [管理员快速参考](管理员快速参考.md) - 常用管理命令
- [远程访问配置](docs/remote-access.md) - 详细的远程访问指南
- [故障排除](docs/troubleshooting.md) - 常见问题解决

### 开发文档
- [GitHub 部署指南](docs/github-setup.md) - 如何部署到 GitHub
- [项目总结](SUMMARY.md) - 完整的项目概述

---

## 🛠️ 常用命令

### 管理员命令

```bash
# 创建用户
sudo ./scripts/quick-create-user.sh username

# 查看所有用户
dscl . list /Users | grep -v "^_"

# 查看登录用户
who

# 查看 Claude 进程
ps aux | grep claude

# 重启 SSH 服务
sudo launchctl unload /System/Library/LaunchDaemons/com.openssh.sshd.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.openssh.sshd.plist
```

### 用户命令

```bash
# 连接到服务器
ssh username@server-ip

# 启动 tmux 会话
tmux new -s main

# 连接到现有会话
tmux attach -t main

# 启动 Claude Code
claude

# 分离会话
Ctrl-a d
```

---

## 🌐 远程访问方案

### 方案对比

| 方案 | 难度 | 安全性 | 稳定性 | 成本 | 推荐度 |
|------|------|--------|--------|------|--------|
| 端口转发 | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | 免费 | ⭐⭐⭐⭐ |
| DDNS | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | 免费 | ⭐⭐⭐⭐ |
| Tailscale | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 免费 | ⭐⭐⭐⭐⭐ |

详细配置请查看 [远程访问指南](docs/remote-access.md)

---

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📝 更新日志

### v1.0.0 (2026-03-01)

- ✨ 初始版本发布
- ✅ 支持一键创建用户
- ✅ 自动配置开发环境
- ✅ SSH 远程访问支持
- ✅ 完整的文档和指南

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [Oh My Zsh](https://ohmyz.sh/) - 强大的 Zsh 配置框架
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - 美观的终端主题
- [Tmux](https://github.com/tmux/tmux) - 终端复用器
- [Claude Code](https://claude.ai/) - AI 编程助手
- [Homebrew](https://brew.sh/) - macOS 包管理器

---

## 📞 联系方式

- 📧 Email: your-email@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/mac-multi-user-setup/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/your-username/mac-multi-user-setup/discussions)

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给个 Star！**

Made with ❤️ by [Your Name](https://github.com/your-username)

</div>
