# 🚀 推送到 GitHub 指南

## 步骤 1：在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `mac-multi-user-setup`
   - **Description**: `🚀 一键部署多用户 Claude Code 开发环境 | Automated multi-user Claude Code setup for Mac mini`
   - **Visibility**: Public 或 Private（根据需求）
   - ⚠️ **不要**勾选 "Initialize this repository with a README"
3. 点击 "Create repository"

## 步骤 2：推送代码

在终端执行以下命令：

```bash
cd /Users/lisicheng/mac-multi-user-setup

# 添加远程仓库（替换 YOUR-USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR-USERNAME/mac-multi-user-setup.git

# 推送代码
git branch -M main
git push -u origin main
```

### 如果使用 SSH（推荐）

```bash
# 添加远程仓库（SSH 方式）
git remote add origin git@github.com:YOUR-USERNAME/mac-multi-user-setup.git

# 推送代码
git branch -M main
git push -u origin main
```

## 步骤 3：配置 Git 用户信息（如果需要）

```bash
# 设置全局用户信息
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 或只为当前仓库设置
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

## 步骤 4：验证推送

访问你的 GitHub 仓库页面，应该能看到：
- ✅ 专业的 README 展示
- ✅ 所有脚本和文档
- ✅ MIT License
- ✅ 完整的提交历史

## 后续更新

当你修改代码后：

```bash
# 查看修改
git status

# 添加修改
git add .

# 提交
git commit -m "描述你的修改"

# 推送
git push
```

## 🎨 美化仓库（可选）

### 添加 Topics

在 GitHub 仓库页面：
1. 点击右侧的 ⚙️ 设置图标
2. 添加 Topics：
   - `macos`
   - `claude-code`
   - `multi-user`
   - `automation`
   - `ssh`
   - `tmux`
   - `zsh`
   - `development-environment`

### 添加 About

在仓库页面右侧：
1. 点击 "About" 旁边的 ⚙️
2. 填写 Description：
   ```
   🚀 一键部署多用户 Claude Code 开发环境 | Automated multi-user Claude Code setup for Mac mini
   ```
3. 添加 Website（如果有）
4. 勾选 "Releases" 和 "Packages"

### 创建第一个 Release

```bash
# 打标签
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

然后在 GitHub 上：
1. 进入 "Releases" 页面
2. 点击 "Draft a new release"
3. 选择 tag `v1.0.0`
4. 填写 Release notes
5. 发布

## 📝 推荐的 README 更新

推送后，你可能需要更新 README 中的以下内容：

1. **替换占位符**：
   - `your-username` → 你的 GitHub 用户名
   - `your-email@example.com` → 你的邮箱
   - `Your Name` → 你的名字

2. **添加实际链接**：
   ```bash
   # 在 README.md 中搜索并替换
   sed -i '' 's/your-username/YOUR-ACTUAL-USERNAME/g' README.md
   git add README.md
   git commit -m "Update README with actual username"
   git push
   ```

## 🔐 使用 SSH 密钥（推荐）

如果还没有配置 SSH 密钥：

```bash
# 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your.email@example.com"

# 启动 ssh-agent
eval "$(ssh-agent -s)"

# 添加密钥
ssh-add ~/.ssh/id_ed25519

# 复制公钥
cat ~/.ssh/id_ed25519.pub
```

然后：
1. 访问 https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴公钥
4. 保存

## ✅ 完成！

你的项目现在已经在 GitHub 上了！

访问：`https://github.com/YOUR-USERNAME/mac-multi-user-setup`

---

**需要帮助？** 查看 [GitHub 文档](https://docs.github.com/)
