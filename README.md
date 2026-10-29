# 三语词卡 Trois Mots

用图片记单词，中文、English、Français 三语对照，内置记忆曲线（间隔重复）。
为"母语中文、会英语、正在学法语"的人设计。

## 功能

- **图片正面，三语背面**：先看图在心里说出法语，再翻面核对。
- **按分类学习**：体育、厨房、工具、交通、动物、水果、蔬菜、衣物。
- **发音可单独开关**：中、英、法各自控制是否朗读，可调顺序和语速；每个词旁边都有喇叭按钮。
- **法语阴阳性上色**：阳性蓝色，阴性红色，单词带冠词（le / la / l' / les）。
- **记忆曲线**：每张卡按"忘了 / 模糊 / 记得 / 很简单"打分，自动安排下次复习时间。
  - 参数全部可调：每日新词上限、第一次和第二次间隔、熟练系数、"模糊"倍数、"很简单"奖励、"忘了"扣分、最长间隔。
  - 提供三套预设：标准、冲刺、轻松。
- **自由练习模式**：随便翻看，不影响复习计划。
- **账号与云同步**：用邮箱验证码登录，进度自动同步到云端，换手机、换电脑都能接着学。不登录也能在本机使用。

## 使用

直接用浏览器打开 `index.html` 即可，不需要安装任何东西。

在 iPhone 上：用 Safari 打开网址 → 点"分享" → "添加到主屏幕"，就能像 App 一样使用。

## 记忆曲线算法

基于 SM-2 算法的简化改良版：

| 评分 | 效果 |
|---|---|
| 忘了 | 间隔归零，本轮稍后再出现一次；熟练系数减少"忘了扣分" |
| 模糊 | 间隔 × "模糊倍数"；熟练系数 −0.15 |
| 记得 | 第 1 次 → 第一次间隔；第 2 次 → 第二次间隔；之后 → 上次间隔 × 熟练系数 |
| 很简单 | 在"记得"的基础上再 × "很简单奖励"；熟练系数 +0.15 |

熟练系数最低 1.3，间隔不超过"最长间隔"。

## 添加单词

打开 `index.html`，找到 `const CATS = [`，每个词是一行：

```js
["🐱","猫","cat","le chat","m"],
// 图片, 中文, 英文, 法语(带冠词), 阴阳性 m/f, 复数可加 1
["✂️","剪刀","scissors","les ciseaux","m",1],
```

新增分类时，照着已有分类复制一段，改 `id`、`zh`、`fr`、`emoji` 和单词列表。

## 文件说明

| 文件 | 作用 |
|---|---|
| `index.html` | 整个 App：界面、词库、记忆曲线、同步逻辑 |
| `config.js` | Supabase 项目地址和 publishable key |
| `supabase.sql` | 建数据表和权限规则，在 Supabase 后台运行一次 |

## 云同步设置（Supabase，一次性）

1. **建表**：Supabase 后台 → SQL Editor → New query，粘贴 `supabase.sql` 全部内容，点 Run。
2. **邮件改成验证码**：Authentication → Emails（Templates），把 **Magic Link** 和 **Confirm signup** 两个模板的内容都换成下面这段：

   ```html
   <h2>三语词卡 登录验证码</h2>
   <p>你的验证码是：</p>
   <p style="font-size:28px;font-weight:bold;letter-spacing:4px">{{ .Token }}</p>
   <p>请尽快在 App 里输入。如果不是你本人操作，忽略这封邮件即可。</p>
   ```
3. **网址**：Authentication → URL Configuration，Site URL 填 GitHub Pages 网址。

数据安全说明：publishable key 本来就是放在网页里公开的。每个人只能读写自己的数据，由数据库的行级权限（RLS）保证。

注意：Supabase 自带的邮件服务每小时只能发很少几封。用户多了以后，需要在 Authentication → SMTP Settings 接入自己的邮件服务（比如 Resend）。

## 发布到网上（GitHub Pages，免费）

1. 把这个仓库推到 GitHub（`index.html`、`config.js`、`README.md`，`supabase.sql` 也可以一起放）。
2. 进入仓库的 **Settings → Pages**。
3. Source 选 **Deploy from a branch**，分支选 `main`，文件夹选 `/ (root)`，保存。
4. 一两分钟后，网址会显示在页面上，一般是 `https://你的用户名.github.io/trois-mots/`。

## 下一步计划

- [ ] 真实照片替代 emoji
- [ ] 更多分类和词汇（DELF A1 词表）
- [ ] 例句
- [ ] 学习统计图表
- [x] 账号登录，多设备同步进度
- [ ] 打包成 iOS App
- [ ] 等等
