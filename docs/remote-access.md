# 远程 SSH 访问配置指南

本指南将帮助你配置 Mac mini，使其可以从外网通过 SSH 访问。

## 快速开始

### 1. 启用 SSH 服务

```bash
# 运行 SSH 配置脚本
sudo ./scripts/setup-ssh-access.sh
```

这个脚本会：
- ✅ 启用 macOS 远程登录
- ✅ 配置 SSH 安全设置
- ✅ 添加防火墙例外
- ✅ 显示本地 IP 地址

### 2. 测试本地连接

```bash
# 从同一网络的另一台设备测试
ssh username@192.168.x.x
```

## 外网访问配置

### 方案 A：路由器端口转发（推荐）

适用于家庭/办公室网络，有路由器管理权限。

#### 步骤：

1. **获取 Mac mini 的本地 IP**
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
   例如：`192.168.1.100`

2. **设置静态 IP（推荐）**
   - 系统设置 > 网络 > Wi-Fi/以太网 > 详细信息
   - 配置 IPv4：手动
   - 设置固定 IP：`192.168.1.100`

3. **配置路由器端口转发**

   登录路由器管理界面（通常是 `192.168.1.1` 或 `192.168.0.1`）

   添加端口转发规则：
   ```
   外部端口: 2222 (或其他非标准端口)
   内部 IP: 192.168.1.100
   内部端口: 22
   协议: TCP
   ```

4. **获取公网 IP**
   ```bash
   curl ifconfig.me
   ```
   或访问：https://whatismyipaddress.com/

5. **从外网连接**
   ```bash
   ssh -p 2222 username@your-public-ip
   ```

### 方案 B：动态 DNS（DDNS）

如果你的公网 IP 会变化，使用 DDNS 服务。

#### 推荐服务：
- [No-IP](https://www.noip.com/) - 免费
- [DuckDNS](https://www.duckdns.org/) - 免费
- [Dynu](https://www.dynu.com/) - 免费

#### 配置步骤：

1. **注册 DDNS 服务**
   - 创建账号
   - 获取域名（如 `mymac.ddns.net`）

2. **在 Mac 上安装 DDNS 客户端**
   ```bash
   # 使用 ddclient
   brew install ddclient
   ```

3. **配置 ddclient**
   ```bash
   sudo nano /usr/local/etc/ddclient.conf
   ```

   添加配置（以 No-IP 为例）：
   ```
   protocol=noip
   use=web
   server=dynupdate.no-ip.com
   login=your-username
   password='your-password'
   mymac.ddns.net
   ```

4. **启动 ddclient**
   ```bash
   sudo brew services start ddclient
   ```

5. **连接**
   ```bash
   ssh -p 2222 username@mymac.ddns.net
   ```

### 方案 C：Tailscale / ZeroTier（最简单）

使用 VPN 网络，无需端口转发。

#### Tailscale 配置：

1. **安装 Tailscale**
   ```bash
   brew install tailscale
   sudo tailscale up
   ```

2. **在客户端设备上也安装 Tailscale**

3. **连接**
   ```bash
   # Tailscale 会分配一个固定的内网 IP
   ssh username@100.x.x.x
   ```

优点：
- ✅ 无需配置路由器
- ✅ 自动加密
- ✅ 穿透 NAT
- ✅ 跨平台支持

## SSH 密钥认证（强烈推荐）

### 在客户端生成 SSH 密钥

```bash
# 生成密钥对
ssh-keygen -t ed25519 -C "your_email@example.com"

# 或使用 RSA（兼容性更好）
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### 将公钥复制到服务器

```bash
# 方法 1：使用 ssh-copy-id
ssh-copy-id -p 2222 username@your-server

# 方法 2：手动复制
cat ~/.ssh/id_ed25519.pub | ssh -p 2222 username@your-server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 禁用密码登录（可选，更安全）

在服务器上编辑 SSH 配置：

```bash
sudo nano /etc/ssh/sshd_config.d/custom.conf
```

取消注释：
```
PasswordAuthentication no
```

重启 SSH：
```bash
sudo launchctl unload /System/Library/LaunchDaemons/com.openssh.sshd.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.openssh.sshd.plist
```

## 安全最佳实践

### 1. 更改默认 SSH 端口

编辑配置：
```bash
sudo nano /etc/ssh/sshd_config.d/custom.conf
```

取消注释并修改：
```
Port 2222
```

### 2. 限制允许登录的用户

```bash
sudo nano /etc/ssh/sshd_config.d/custom.conf
```

添加：
```
AllowUsers alice bob charlie
```

### 3. 使用 Fail2Ban 防止暴力破解

```bash
# 安装 fail2ban
brew install fail2ban

# 配置（创建本地配置）
sudo cp /usr/local/etc/fail2ban/jail.conf /usr/local/etc/fail2ban/jail.local

# 编辑配置
sudo nano /usr/local/etc/fail2ban/jail.local
```

添加 SSH 保护：
```ini
[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/system.log
maxretry = 3
bantime = 3600
```

启动服务：
```bash
sudo brew services start fail2ban
```

### 4. 配置防火墙

```bash
# 启用防火墙
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# 允许 SSH
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/sbin/sshd
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /usr/sbin/sshd
```

### 5. 监控 SSH 登录

查看登录日志：
```bash
# 查看最近的 SSH 登录
log show --predicate 'process == "sshd"' --last 1h

# 查看认证日志
log show --predicate 'eventMessage contains "sshd"' --info --last 1d
```

## 多用户访问管理

### 为每个用户创建独立的 SSH 配置

```bash
# 用户 alice 只能从特定 IP 访问
sudo nano /etc/ssh/sshd_config.d/custom.conf
```

添加：
```
Match User alice
    AllowUsers alice
    PermitRootLogin no

Match User bob
    AllowUsers bob
    PasswordAuthentication no
```

### 用户连接示例

```bash
# 用户 alice 从外网连接
ssh -p 2222 alice@mymac.ddns.net

# 进入后启动 tmux 和 Claude Code
tmux new -s alice-session
claude
```

## 客户端配置（~/.ssh/config）

在客户端创建 SSH 配置文件，简化连接：

```bash
nano ~/.ssh/config
```

添加：
```
Host macmini
    HostName mymac.ddns.net
    Port 2222
    User alice
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host macmini-bob
    HostName mymac.ddns.net
    Port 2222
    User bob
    IdentityFile ~/.ssh/id_ed25519
```

现在可以简单地连接：
```bash
ssh macmini
```

## 故障排除

### 无法连接

1. **检查 SSH 服务状态**
   ```bash
   sudo launchctl list | grep ssh
   ```

2. **检查端口是否开放**
   ```bash
   sudo lsof -i :22
   ```

3. **测试本地连接**
   ```bash
   ssh localhost
   ```

4. **查看 SSH 日志**
   ```bash
   log show --predicate 'process == "sshd"' --last 10m
   ```

### 端口转发不工作

1. 确认路由器配置正确
2. 检查 ISP 是否封锁了端口
3. 尝试使用不同的外部端口（如 2222, 2200）
4. 确认防火墙规则

### 连接很慢

在 SSH 配置中添加：
```
UseDNS no
GSSAPIAuthentication no
```

## 性能优化

### 启用 SSH 连接复用

客户端配置：
```
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

### 压缩传输

```bash
ssh -C -p 2222 username@server
```

或在配置中：
```
Compression yes
```

## 自动化脚本

### 一键连接并启动 Claude

创建客户端脚本 `connect-claude.sh`：
```bash
#!/bin/bash
ssh -t macmini "tmux attach -t claude || tmux new -s claude 'claude'"
```

## 监控和维护

### 查看当前连接的用户

```bash
who
# 或
w
```

### 查看 SSH 连接历史

```bash
last | grep ssh
```

### 定期更新系统

```bash
sudo softwareupdate -l
sudo softwareupdate -i -a
```

## 安全检查清单

- [ ] SSH 密钥认证已配置
- [ ] 密码认证已禁用（或使用强密码）
- [ ] SSH 端口已更改（非 22）
- [ ] 防火墙已启用
- [ ] Fail2Ban 已配置
- [ ] 只允许特定用户登录
- [ ] 定期检查登录日志
- [ ] 系统保持更新
- [ ] 使用 DDNS 或 Tailscale
- [ ] 路由器端口转发配置正确

## 推荐工具

- **Termius** - 跨平台 SSH 客户端（iOS/Android/Desktop）
- **Blink Shell** - iOS 上的专业 SSH 客户端
- **tmux** - 保持会话持久化
- **mosh** - 移动环境下的 SSH 替代品（更稳定）

## 获取帮助

如有问题，请查看：
- [SSH 官方文档](https://www.openssh.com/)
- [macOS SSH 配置](https://support.apple.com/guide/mac-help/mchlp1066/mac)
- 项目 Issues: https://github.com/your-username/mac-multi-user-setup/issues
