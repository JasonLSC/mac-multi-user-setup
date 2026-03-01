# GitHub 部署指南

## 1. 在 GitHub 上创建仓库

访问 https://github.com/new 创建新仓库：

- Repository name: `mac-multi-user-setup`
- Description: `Automated setup for hosting Claude Code for multiple users on Mac mini`
- Visibility: Public 或 Private（根据需求）
- 不要初始化 README、.gitignore 或 license（我们已经有了）

## 2. 推送到 GitHub

```bash
# 添加远程仓库（替换 your-username）
git remote add origin https://github.com/your-username/mac-multi-user-setup.git

# 推送代码
git branch -M main
git push -u origin main
```

## 3. 配置 Git 用户信息（如果需要）

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 4. 使用 SSH（推荐）

如果你想使用 SSH 而不是 HTTPS：

```bash
# 生成 SSH 密钥（如果还没有）
ssh-keygen -t ed25519 -C "your.email@example.com"

# 添加到 ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 复制公钥
cat ~/.ssh/id_ed25519.pub
# 然后在 GitHub Settings > SSH Keys 中添加

# 更改远程 URL 为 SSH
git remote set-url origin git@github.com:your-username/mac-multi-user-setup.git
```

## 5. 后续更新

当你修改配置后：

```bash
# 查看修改
git status

# 添加修改
git add .

# 提交
git commit -m "Update configuration"

# 推送
git push
```

## 6. 在其他 Mac 上使用

```bash
# 克隆仓库
git clone https://github.com/your-username/mac-multi-user-setup.git
cd mac-multi-user-setup

# 开始使用
sudo ./scripts/create-user.sh username api_key
```

## 7. 保持更新

在已部署的机器上：

```bash
cd mac-multi-user-setup
git pull
# 然后重新应用配置到用户
```

## 安全提示

⚠️ **重要**: 永远不要将 API keys 提交到 Git！

- API keys 应该通过命令行参数传递
- 或者使用环境变量
- 或者在部署后手动配置

如果不小心提交了敏感信息：

```bash
# 从历史中删除文件
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/sensitive/file" \
  --prune-empty --tag-name-filter cat -- --all

# 强制推送（谨慎使用）
git push origin --force --all
```

## 项目维护

### 创建 Release

```bash
# 打标签
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

### 分支管理

```bash
# 创建开发分支
git checkout -b develop

# 合并到主分支
git checkout main
git merge develop
git push
```
