# App Store Connect 必填字段

这份清单用于你截图里的「分发 > App 信息」和后续「准备提交」页面。

## App 信息

- 副标题：初中信奥刷题、资料与避坑
- 主要语言：简体中文
- 套装 ID：保持当前已选 bundle id
- SKU：保持当前值即可
- 类别主要：教育
- 类别次要：参考资料
- 许可协议：Apple 标准许可协议

## 内容版权

- 内容版权声明：© 2026 Chen Tingting
- 内容权利：不包含、显示或访问第三方内容

本 app 的题库、参考资料、图标、界面和文案都是项目内原创整理内容；没有内置第三方文章、视频、图片、音乐或联网内容。

## App 隐私

- 数据收集：不收集数据
- 追踪：不追踪用户
- 第三方广告：无
- 登录账号：无
- 服务器上传：无

当前版本的完成状态、收藏、笔记和检查清单都保存在设备本地 `UserDefaults`，不会上传到服务器。

## 年龄分级建议

- 建议分级：4+
- 暴力、成人内容、赌博、医疗、用户生成内容、网页访问：全部选择无
- 教育类算法刷题工具，没有社交、聊天或开放网页浏览

## 出口合规

- 是否使用加密：否

如果 App Store Connect 解释为“是否使用 Apple 系统以外的专有加密算法”，本 app 不使用自定义加密、VPN、证书管理、加密通讯功能。

## 价格与销售范围

- 价格：免费
- 销售范围：按默认所有可用地区即可

## 隐私政策与支持 URL

当前仓库没有配置公开 GitHub remote，所以还不能生成可直接填写的线上 URL。可以先把 `docs/privacy.html` 和 `docs/support.html` 部署到 GitHub Pages，再填写：

- 隐私政策 URL：`https://<你的 GitHub 用户名>.github.io/<隐私页面仓库>/privacy.html`
- 支持 URL：`https://<你的 GitHub 用户名>.github.io/<隐私页面仓库>/support.html`

部署后再把这两个 URL 写入：

- `fastlane/metadata/zh-Hans/privacy_url.txt`
- `fastlane/metadata/zh-Hans/support_url.txt`
