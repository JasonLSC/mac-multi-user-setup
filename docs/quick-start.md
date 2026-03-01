# 快速使用指南

## 一键创建用户

### 基本用法

```bash
# 1. 克隆仓库（首次使用）
git clone https://github.com/your-username/mac-multi-user-setup.git
cd mac-multi-user-setup

# 2. 创建用户（不带 API key）
sudo ./scripts/create-user.sh alice

# 3. 创建用户（带 API key，推荐）
sudo ./scripts/create-user.sh bob sk-ant-api03-xxxxx
```

### 创建多个用户示例

```bash
# 为团队创建 3 个用户
sudo ./scripts/create-user.sh developer1 sk-ant-api03-key1
sudo ./scripts/create-user.sh developer2 sk-ant-api03-key2
sudo ./scripts/create-user.sh developer3 sk-ant-api03-key3
```

## 用户登录和使用

### 切换到新用户

```bash
# 方式 1: 使用 su
su - username

# 方式 2: 使用 SSH（如果启用了远程登录）
ssh username@localhost
```

### 启动开发环境

```bash
# 1. 启动 tmux 会话
tmux new -s main

# 2. 在 tmux 中启动 Claude Code
claude

# 3. 分离 tmux 会话（保持后台运行）
# 按 Ctrl-a 然后按 d
```

### 重新连接到会话

```bash
# 列出所有会话
tmux list-sessions

# 连接到指定会话
tmux attach -t main

# 或使用别名
ta main
```

## 多用户并发运行

### 场景：3 个开发者同时工作

```bash
# 用户 1 (alice)
su - alice
tmux new -s alice-dev
claude

# 用户 2 (bob)
su - bob
tmux new -s bob-dev
claude

# 用户 3 (charlie)
su - charlie
tmux new -s charlie-dev
claude
```

### 查看所有运行的 Claude 实例

```bash
ps aux | grep claude | grep -v grep
```

输出示例：
```
alice    1234  ...  claude
bob      5678  ...  claude
charlie  9012  ...  claude
```

## 常用命令速查

### Claude Code
```bash
cc          # 启动 Claude Code
ccc         # 继续上次会话
ccr         # 重置会话
claude --help  # 查看帮助
```

### Tmux
```bash
tn mywork   # 创建名为 mywork 的新会话
ta mywork   # 连接到 mywork 会话
tl          # 列出所有会话
tmux kill-session -t mywork  # 关闭会话
```

### Tmux 快捷键
```
Ctrl-a |    # 垂直分屏
Ctrl-a -    # 水平分屏
Ctrl-a d    # 分离会话
Alt-方向键   # 切换面板
Ctrl-a r    # 重新加载配置
```

## 配置更新

### 更新所有用户的配置

```bash
# 1. 拉取最新配置
cd mac-multi-user-setup
git pull

# 2. 为每个用户更新配置
for user in alice bob charlie; do
    sudo cp templates/.zshrc /Users/$user/.zshrc
    sudo cp templates/.tmux.conf /Users/$user/.tmux.conf
    sudo chown $user:staff /Users/$user/.zshrc /Users/$user/.tmux.conf
done

# 3. 通知用户重新加载配置
# 用户需要运行: source ~/.zshrc
```

### 单个用户更新

```bash
# 以该用户身份登录
su - username

# 拉取最新配置
cd /path/to/mac-multi-user-setup
git pull

# 应用配置
cp templates/.zshrc ~/.zshrc
cp templates/.tmux.conf ~/.tmux.conf
source ~/.zshrc
```

## 故障排除

### 用户无法登录
```bash
# 检查用户是否存在
id username

# 重置密码
sudo passwd username
```

### Claude Code 未安装
```bash
# 手动安装
brew install claude

# 配置 API key
claude config
```

### Tmux 会话丢失
```bash
# 列出所有会话
tmux list-sessions

# 如果没有会话，创建新的
tmux new -s main
```

## 最佳实践

1. **为每个用户使用独立的 API key**，避免配额冲突
2. **使用 tmux 保持会话**，即使断开连接也能继续工作
3. **定期更新配置**，获取最新的功能和优化
4. **监控系统资源**，确保 Mac mini 有足够的性能
5. **备份重要数据**，定期备份用户的工作目录

## 性能建议

### Mac mini 资源分配建议

- **8GB RAM**: 最多 2-3 个并发用户
- **16GB RAM**: 最多 4-5 个并发用户
- **32GB RAM**: 最多 8-10 个并发用户

### 监控资源使用

```bash
# 查看内存使用
top -l 1 | grep PhysMem

# 查看 CPU 使用
top -l 1 | grep "CPU usage"

# 查看所有 Claude 进程
ps aux | grep claude | awk '{print $2, $3, $4, $11}'
```

## 安全建议

1. 为每个用户设置强密码
2. 不要在脚本中硬编码 API key
3. 定期更新系统和软件包
4. 限制用户的 sudo 权限（如果不需要）
5. 启用 macOS 防火墙

## 获取帮助

- 查看完整文档: `cat README.md`
- 故障排除: `cat docs/troubleshooting.md`
- 提交问题: https://github.com/your-username/mac-multi-user-setup/issues
