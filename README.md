# PodcastListApp

一个简易的 SwiftUI 播客节目列表练习项目。数据来自本地 JSON，点击列表项可以切换“正在播放”状态，同一时间只有一个节目处于播放中。

## 项目简介

项目目标用最基础的 SwiftUI + MVVM 结构，实现一个MVP可交互的播客列表页面，并处理 iPhone 多尺寸和 Dark Mode 的适配。重点在数据加载、状态管理和 UI 组合上而非真实音频·。

## 已完成功能

核心功能：

- 播客节目列表展示（标题、主播、简介、时长、封面占位）
- 本地 JSON 数据读取（`Bundle` + `JSONDecoder`）
- 点击切换正在播放状态
- 同一时间只有一个节目处于播放中
- iPhone 不同屏幕尺寸适配（iPhone SE 到 iPhone 15 Pro Max）
- Dark Mode 适配（全程使用系统语义色）

加分功能：

- 底部“正在播放”悬浮条（`.safeAreaInset(edge: .bottom)` + `.ultraThinMaterial`）
- 模拟下拉刷新（SwiftUI 原生 `.refreshable`，用 `Task.sleep` 模拟延迟）
- 基础 VoiceOver 支持（悬浮条使用合并后的 `accessibilityLabel`）

## 技术选型

- 语言：Swift
- UI：SwiftUI
- 最低支持：iOS 17
- 架构：轻量 MVVM
- 数据解析：`Codable`
- 异步：`async/await` + `@MainActor`
- 状态管理：`ObservableObject` + `@Published` + `@StateObject`

## 项目结构

```text
PodcastListApp/
├── PodcastListApp.xcodeproj
├── README.md
└── PodcastListApp/
    ├── PodcastListAppApp.swift          
    ├── ContentView.swift               
    ├── Models/
    │   └── PodcastEpisode.swift         
    ├── Services/
    │   └── PodcastDataLoader.swift      
    ├── ViewModels/
    │   └── PodcastListViewModel.swift   
    ├── Views/
    │   ├── PodcastListView.swift        
    │   ├── PodcastRowView.swift         
    │   └── NowPlayingBar.swift          
    ├── Resources/
    │   └── podcasts.json               
    └── Assets.xcassets
```

## AI 工具使用说明

我在开发过程中使用了 ChatGPT 和 Cursor 辅助，主要用于：

- 前期的项目结构规划（Models / Views / ViewModels / Services 的划分）
- 部分模板代码的起稿（比如 `PodcastDataLoader` 的错误类型、`#Preview` 的样板数据）
- 一些 SwiftUI API 的确认（比如 `safeAreaInset` 与 `ZStack` 的区别、`.refreshable` 的行为）
- 最后阶段的代码检查与 Dark Mode 适配审查

所有生成的代码我都自己阅读过、调整过命名和结构，并在 Xcode 里跑起来逐个验证过效果。对每一处设计选择（为什么用 `List` 而不是 `ScrollView + LazyVStack`、为什么用 `ObservableObject` 而不是 iOS 17 的 `@Observable`、为什么把“查找当前播放节目”的逻辑放在 View 而不是 VM 等），我能解释清楚原因。

AI 更多是扮演“搭伙讨论 + 模板加速”的角色，项目的结构选择和具体取舍是我自己拍板的。

## 后续可改进方向

- **真实音频播放**：接入 `AVPlayer`，加入播放进度条、暂停 / 继续、后台播放、锁屏控制等。
- **网络数据**：把 `PodcastDataLoader` 抽象成 `PodcastDataSource` 协议，新增一个基于 `URLSession` 的实现，VM 在初始化时注入，便于单元测试与切换。
- **搜索功能**：给列表加 `.searchable`，按标题 / 主播过滤。
- **分类筛选**：为节目加 `category` 字段，顶部加标签栏或者分段控件进行筛选。
- **错误态 UI**：利用 `PodcastDataLoaderError` 已有的分类，在加载失败时显示可重试的空态视图。
- **详情页**：点击节目进入详情，展示更长的简介、更多元数据。
- **播放记录 / 收藏**：使用 `SwiftData` 或 `UserDefaults` 做本地持久化。

## 项目取舍

- 不做真实音频播放：时间盒内做不稳。
- 不做详情页 / 搜索 / 收藏：为了在 2–4 小时内把核心功能和代码质量做扎实。
- `togglePlayback` 的命名：方法名偏向 "toggle"，但实际语义是 "select"（再次点击同一条不会取消）。原始需求约定如此，保留不变。
- 没用 iOS 17 的 `@Observable` 宏：需求里指定了 `ObservableObject` + `@Published`，按要求实现。
