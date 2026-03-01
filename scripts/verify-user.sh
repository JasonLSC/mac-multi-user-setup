#!/bin/bash

USERNAME=$1
USER_HOME="/Users/$USERNAME"

echo "================================"
echo "🔍 验证用户安装: $USERNAME"
echo "================================"
echo ""

PASS=0
TOTAL=0

# 检查 Oh My Zsh
TOTAL=$((TOTAL + 1))
if [ -d "$USER_HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh 已安装"
    PASS=$((PASS + 1))
else
    echo "❌ Oh My Zsh 未安装"
fi

# 检查 Powerlevel10k
TOTAL=$((TOTAL + 1))
if [ -d "$USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "✅ Powerlevel10k 主题已安装"
    PASS=$((PASS + 1))
else
    echo "❌ Powerlevel10k 主题未安装"
fi

# 检查 Zsh 插件
TOTAL=$((TOTAL + 1))
if [ -d "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && \
   [ -d "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && \
   [ -d "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    echo "✅ Zsh 插件已安装"
    PASS=$((PASS + 1))
else
    echo "❌ 部分 Zsh 插件未安装"
fi

# 检查配置文件
TOTAL=$((TOTAL + 1))
if [ -f "$USER_HOME/.zshrc" ] && [ -f "$USER_HOME/.tmux.conf" ]; then
    echo "✅ 配置文件已复制"
    PASS=$((PASS + 1))
else
    echo "❌ 配置文件缺失"
fi

# 检查 tmux
TOTAL=$((TOTAL + 1))
if command -v tmux &> /dev/null || [ -f "/opt/homebrew/bin/tmux" ]; then
    echo "✅ tmux 可用"
    PASS=$((PASS + 1))
else
    echo "❌ tmux 未安装"
fi

# 检查 Claude Code
TOTAL=$((TOTAL + 1))
if command -v claude &> /dev/null || [ -f "/opt/homebrew/bin/claude" ] || [ -f "$USER_HOME/.local/bin/claude" ]; then
    echo "✅ Claude Code 可用"
    PASS=$((PASS + 1))
else
    echo "❌ Claude Code 未安装（需要手动安装）"
fi

# 检查代理配置
TOTAL=$((TOTAL + 1))
if grep -q "https_proxy" "$USER_HOME/.zshrc"; then
    echo "✅ 代理配置已添加"
    PASS=$((PASS + 1))
else
    echo "❌ 代理配置缺失"
fi

echo ""
echo "================================"
echo "验证结果: $PASS/$TOTAL 项通过"
echo "================================"

if [ $PASS -eq $TOTAL ]; then
    echo "🎉 所有检查通过！"
    exit 0
else
    echo "⚠️  部分项目需要手动安装"
    exit 1
fi
