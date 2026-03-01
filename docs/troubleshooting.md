# 故障排除指南

## 常见问题

### 1. 用户创建失败

**问题**: `sysadminctl` 命令失败

**解决方案**:
```bash
# 检查是否有足够权限
sudo -v

# 手动创建用户
sudo dscl . -create /Users/username
sudo dscl . -create /Users/username UserShell /bin/zsh
sudo dscl . -create /Users/username RealName "Full Name"
sudo dscl . -create /Users/username UniqueID 501
sudo dscl . -create /Users/username PrimaryGroupID 20
sudo dscl . -create /Users/username NFSHomeDirectory /Users/username
sudo dscl . -passwd /Users/username password
sudo createhomedir -c -u username
```

### 2. Homebrew 安装问题

**问题**: Homebrew 安装超时或失败

**解决方案**:
```bash
# 使用国内镜像（如果在中国）
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

# 重新安装
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Oh My Zsh 插件不工作

**问题**: 自动补全或语法高亮不生效

**解决方案**:
```bash
# 检查插件是否正确安装
ls ~/.oh-my-zsh/custom/plugins/

# 重新克隆插件
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# 重新加载配置
source ~/.zshrc
```

### 4. Tmux 配置未生效

**问题**: Tmux 快捷键不工作

**解决方案**:
```bash
# 在 tmux 会话中重新加载配置
tmux source-file ~/.tmux.conf

# 或者重启 tmux 服务器
tmux kill-server
tmux
```

### 5. Claude Code API 配置问题

**问题**: Claude Code 无法连接 API

**解决方案**:
```bash
# 检查配置文件
cat ~/.claude/config.json

# 重新配置
claude config

# 测试连接
claude --version
```

### 6. 权限问题

**问题**: 配置文件权限错误

**解决方案**:
```bash
# 修复主目录权限
sudo chown -R $USER:staff ~/
chmod 755 ~/

# 修复特定配置文件
chmod 644 ~/.zshrc ~/.tmux.conf
```

### 7. 多用户冲突

**问题**: 多个用户的 Claude Code 实例冲突

**解决方案**:
- 确保每个用户使用不同的 API key
- 检查进程：`ps aux | grep claude`
- 每个用户在独立的 tmux 会话中运行

### 8. 系统代理设置

**问题**: 需要配置系统代理

**解决方案**:
```bash
# 查看当前代理设置
scutil --proxy

# 设置 HTTP 代理
networksetup -setwebproxy "Wi-Fi" proxy.example.com 8080

# 设置 HTTPS 代理
networksetup -setsecurewebproxy "Wi-Fi" proxy.example.com 8080

# 或在 ~/.zshrc 中添加
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
```

## 性能优化

### 减少 Zsh 启动时间

```bash
# 在 ~/.zshrc 开头添加
# zmodload zsh/zprof

# 在 ~/.zshrc 结尾添加
# zprof
```

### Tmux 性能优化

```bash
# 在 ~/.tmux.conf 中添加
set -g status-interval 5  # 降低状态栏刷新频率
```

## 日志和调试

### 查看安装日志

```bash
# 运行脚本时保存日志
sudo ./scripts/create-user.sh username 2>&1 | tee setup.log
```

### 调试 Zsh 配置

```bash
# 启动 Zsh 调试模式
zsh -x
```

### 调试 Tmux

```bash
# 查看 Tmux 服务器信息
tmux info
```

## 获取帮助

如果以上方法都无法解决问题，请：

1. 查看完整错误信息
2. 在 GitHub Issues 中搜索类似问题
3. 提交新的 Issue，包含：
   - macOS 版本
   - 错误信息
   - 执行的命令
   - 相关日志
