# Claude Code 手动安装指南

由于网络限制，Claude Code 需要手动安装。

## 安装方法

### 方法 1：使用官方安装脚本（推荐）

```bash
# 以目标用户登录后运行
curl -fsSL https://claude.ai/install.sh | bash
```

### 方法 2：从官网下载

1. 访问 https://claude.ai/download
2. 下载 macOS 版本
3. 安装到 Applications
4. 在终端中运行 `claude` 命令

### 方法 3：使用 npm（如果可用）

```bash
npm install -g @anthropic-ai/claude-cli
```

## 验证安装

安装完成后，运行：

```bash
claude --version
```

## 配置 API Key

```bash
claude config
```

按提示输入你的 API key。

## 故障排除

### 命令找不到

如果安装后命令找不到，检查 PATH：

```bash
echo $PATH
```

确保包含 Claude 的安装目录（通常是 `~/.local/bin`）。

如果没有，添加到 `.zshrc`：

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 网络问题

如果下载失败，确保代理已配置：

```bash
export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
```

然后重试安装。

## 当前状态

- ✅ tmux 已安装并可用
- ✅ Oh My Zsh 已配置
- ✅ 所有插件已安装
- ⚠️ Claude Code 需要手动安装

## 快速验证

运行验证脚本检查所有组件：

```bash
sudo ./scripts/verify-user.sh yuanboyang
```
