# 远程访问快速参考

## 服务器端设置

### 1. 启用 SSH（一次性）
```bash
sudo ./scripts/setup-ssh-access.sh
```

### 2. 获取连接信息
```bash
# 本地 IP
ifconfig | grep "inet " | grep -v 127.0.0.1

# 公网 IP
curl ifconfig.me
```

### 3. 配置路由器端口转发
```
外部端口: 2222
内部 IP: 192.168.x.x (Mac mini 的 IP)
内部端口: 22
协议: TCP
```

## 客户端连接

### 基本连接
```bash
# 本地网络
ssh username@192.168.x.x

# 外网（需要端口转发）
ssh -p 2222 username@your-public-ip

# 使用域名（需要 DDNS）
ssh -p 2222 username@mymac.ddns.net
```

### 使用 SSH 密钥（推荐）
```bash
# 生成密钥
ssh-keygen -t ed25519

# 复制到服务器
ssh-copy-id -p 2222 username@server

# 连接（无需密码）
ssh -p 2222 username@server
```

### 简化配置（~/.ssh/config）
```
Host macmini
    HostName mymac.ddns.net
    Port 2222
    User alice
    IdentityFile ~/.ssh/id_ed25519
```

连接：
```bash
ssh macmini
```

## 启动 Claude Code

### 方式 1：手动启动
```bash
ssh macmini
tmux new -s claude
claude
# Ctrl-a d 分离会话
```

### 方式 2：自动连接到会话
```bash
ssh -t macmini "tmux attach -t claude || tmux new -s claude"
```

### 方式 3：一键启动 Claude
```bash
ssh -t macmini "tmux attach -t claude || tmux new -s claude 'claude'"
```

## 常用命令

### 查看运行的会话
```bash
ssh macmini "tmux list-sessions"
```

### 重新连接到会话
```bash
ssh -t macmini "tmux attach -t claude"
```

### 查看所有用户
```bash
ssh macmini "who"
```

### 查看 Claude 进程
```bash
ssh macmini "ps aux | grep claude"
```

## 推荐方案对比

| 方案 | 难度 | 安全性 | 稳定性 | 成本 |
|------|------|--------|--------|------|
| 端口转发 | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | 免费 |
| DDNS | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | 免费 |
| Tailscale | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 免费 |
| VPS 跳板 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 付费 |

## 安全检查清单

- [ ] SSH 密钥认证已配置
- [ ] 更改了默认 SSH 端口（非 22）
- [ ] 防火墙已启用
- [ ] 只允许特定用户登录
- [ ] 禁用了 root 登录
- [ ] 使用强密码或禁用密码登录
- [ ] 定期检查登录日志

## 故障排除

### 无法连接
```bash
# 1. 检查 SSH 服务
sudo launchctl list | grep ssh

# 2. 检查端口
sudo lsof -i :22

# 3. 测试本地连接
ssh localhost

# 4. 查看日志
log show --predicate 'process == "sshd"' --last 10m
```

### 连接超时
- 检查路由器端口转发配置
- 确认防火墙规则
- 测试公网 IP 是否正确
- 尝试不同的端口

### 密钥认证失败
```bash
# 检查权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519

# 查看详细日志
ssh -vvv username@server
```

## 移动设备访问

### iOS
- **Termius** - 功能强大，支持 SFTP
- **Blink Shell** - 专业终端，支持 mosh

### Android
- **Termux** - 完整的 Linux 环境
- **JuiceSSH** - 简单易用

## 高级技巧

### 使用 mosh（更稳定）
```bash
# 服务器安装
brew install mosh

# 客户端连接
mosh --ssh="ssh -p 2222" username@server
```

### 端口敲门（Port Knocking）
增加额外的安全层，只有特定的端口序列才能打开 SSH。

### 反向 SSH 隧道
如果无法配置路由器，可以使用 VPS 作为跳板。

详细配置请查看：[docs/remote-access.md](remote-access.md)
