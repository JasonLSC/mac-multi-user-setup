#!/bin/bash

# 简化版用户创建脚本
# 适用于快速创建用户并配置基本环境

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# 检查是否为 root
if [ "$EUID" -ne 0 ]; then
    echo "请使用 sudo 运行此脚本"
    echo "用法: sudo $0 <用户名> [密码] [API_key]"
    exit 1
fi

# 获取参数
USERNAME=$1
PASSWORD=${2:-"user2026"}  # 默认密码
API_KEY=$3

if [ -z "$USERNAME" ]; then
    echo "用法: sudo $0 <用户名> [密码] [API_key]"
    echo ""
    echo "示例:"
    echo "  sudo $0 zhangsan                    # 使用默认密码 user2026"
    echo "  sudo $0 zhangsan mypass123          # 指定密码"
    echo "  sudo $0 zhangsan mypass123 sk-ant-xxx  # 指定密码和 API key"
    exit 1
fi

echo "================================"
echo "创建用户: $USERNAME"
echo "================================"
echo ""

# 1. 创建用户
print_step "创建用户账户..."
if id "$USERNAME" &>/dev/null; then
    print_warning "用户 $USERNAME 已存在，跳过创建"
else
    sysadminctl -addUser "$USERNAME" -fullName "$USERNAME" -password "$PASSWORD" -admin
    print_info "用户创建成功"
fi

# 等待主目录创建
sleep 2

USER_HOME="/Users/$USERNAME"

# 2. 设置密码
print_step "设置用户密码..."
dscl . -passwd /Users/$USERNAME "$PASSWORD"
print_info "密码已设置"

# 3. 添加到管理员组
print_step "添加管理员权限..."
dseditgroup -o edit -a "$USERNAME" -t user admin
print_info "已添加到管理员组"

# 4. 复制配置文件
print_step "配置开发环境..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"

if [ -f "$TEMPLATE_DIR/.zshrc" ]; then
    cp "$TEMPLATE_DIR/.zshrc" "$USER_HOME/.zshrc"
    chown "$USERNAME:staff" "$USER_HOME/.zshrc"
    print_info "Zsh 配置已复制"
fi

if [ -f "$TEMPLATE_DIR/.tmux.conf" ]; then
    cp "$TEMPLATE_DIR/.tmux.conf" "$USER_HOME/.tmux.conf"
    chown "$USERNAME:staff" "$USER_HOME/.tmux.conf"
    print_info "Tmux 配置已复制"
fi

# 5. 配置 Claude Code（如果提供了 API key）
if [ -n "$API_KEY" ]; then
    print_step "配置 Claude Code..."
    sudo -u "$USERNAME" mkdir -p "$USER_HOME/.claude"
    echo "{\"apiKey\": \"$API_KEY\"}" > "$USER_HOME/.claude/config.json"
    chown -R "$USERNAME:staff" "$USER_HOME/.claude"
    print_info "API key 已配置"
fi

# 6. 安装 Oh My Zsh 和插件
print_step "安装 Oh My Zsh..."
sudo -u "$USERNAME" sh -c 'RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' 2>/dev/null
if [ -d "$USER_HOME/.oh-my-zsh" ]; then
    print_info "Oh My Zsh 已安装"

    # 安装 Powerlevel10k 主题
    print_step "安装 Powerlevel10k 主题..."
    sudo -u "$USERNAME" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k" 2>/dev/null
    print_info "Powerlevel10k 已安装"

    # 安装 Zsh 插件
    print_step "安装 Zsh 插件..."
    sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-autosuggestions "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null
    sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" 2>/dev/null
    sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-completions "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-completions" 2>/dev/null
    print_info "Zsh 插件已安装"
else
    print_warning "Oh My Zsh 安装失败，用户可稍后手动安装"
fi

# 7. 安装 OpenClaw（个人 AI 助手）
print_step "安装 OpenClaw..."
if command -v npm &> /dev/null; then
    sudo -u "$USERNAME" npm install -g openclaw@latest 2>/dev/null || print_warning "OpenClaw 安装失败，用户可稍后手动安装"
    if [ $? -eq 0 ]; then
        print_info "OpenClaw 已安装"
    fi
else
    print_warning "npm 未安装，跳过 OpenClaw 安装"
fi

# 8. 设置 Zsh 为默认 shell
print_step "设置默认 shell..."
chsh -s /bin/zsh "$USERNAME"
print_info "已设置 Zsh 为默认 shell"

# 9. 创建欢迎文件
cat > "$USER_HOME/.welcome.txt" << EOF
欢迎使用 Mac mini 多用户开发环境！

你的账户信息：
- 用户名: $USERNAME
- 密码: $PASSWORD

快速开始：
1. 启动 tmux: tmux new -s main
2. 配置 Claude: claude config
3. 启动 Claude: claude
4. 使用 OpenClaw: openclaw onboard

详细使用指南请查看：新用户使用指南.md

建议首次登录后修改密码：passwd
EOF

chown "$USERNAME:staff" "$USER_HOME/.welcome.txt"

# 10. 获取 IP 地址
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

echo ""
echo "================================"
echo "✅ 用户创建完成！"
echo "================================"
echo ""
echo "用户信息："
echo "  用户名: $USERNAME"
echo "  密码: $PASSWORD"
if [ -n "$API_KEY" ]; then
    echo "  API Key: 已配置"
fi
echo ""
echo "SSH 连接命令："
echo "  本地网络: ssh $USERNAME@$LOCAL_IP"
echo "  外网访问: ssh -p 2222 $USERNAME@188.253.4.121"
echo ""
echo "首次登录后："
echo "  1. 修改密码: passwd"
echo "  2. 查看欢迎信息: cat ~/.welcome.txt"
if [ -z "$API_KEY" ]; then
    echo "  3. 配置 Claude: claude config"
fi
echo ""
echo "用户指南位置："
echo "  $(dirname "$SCRIPT_DIR")/新用户使用指南.md"
echo ""
