import SwiftUI

enum Difficulty: String, CaseIterable, Identifiable {
    case starter = "入门"
    case standard = "标准"
    case challenge = "提高"

    var id: String { rawValue }

    var tint: Color {
        switch self {
        case .starter:
            .green
        case .standard:
            .blue
        case .challenge:
            .red
        }
    }
}

enum Topic: String, CaseIterable, Identifiable {
    case basics = "基础语法"
    case simulation = "模拟枚举"
    case math = "数论数学"
    case dp = "动态规划"
    case graph = "图论搜索"
    case strings = "字符串"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .basics:
            "curlybraces"
        case .simulation:
            "slider.horizontal.3"
        case .math:
            "function"
        case .dp:
            "square.grid.3x3"
        case .graph:
            "point.3.connected.trianglepath.dotted"
        case .strings:
            "textformat.abc"
        }
    }
}

struct PracticeProblem: Identifiable, Hashable {
    let id: String
    let title: String
    let topic: Topic
    let difficulty: Difficulty
    let estimatedMinutes: Int
    let tags: [String]
    let prompt: String
    let hints: [String]
    let answer: String
    let commonTrap: String
}

struct ReferenceArticle: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let topic: Topic
    let readingMinutes: Int
    let bullets: [String]
}

struct PitfallGuide: Identifiable, Hashable {
    let id: String
    let title: String
    let symptom: String
    let fix: String
    let checklist: [String]
}

struct StudyDay: Identifiable, Hashable {
    let id = UUID()
    let day: String
    let focus: String
    let tasks: [String]
}

enum OlympiadLibrary {
    static let problems: [PracticeProblem] = [
        PracticeProblem(
            id: "sim-001",
            title: "奖学金排序",
            topic: .simulation,
            difficulty: .starter,
            estimatedMinutes: 18,
            tags: ["结构体", "排序", "稳定输出"],
            prompt: "给出 n 名同学的语文、数学、英语成绩，请按总分从高到低排序；总分相同按语文高者优先；仍相同按编号小者优先。输出前 5 名编号和总分。",
            hints: [
                "把编号和三科成绩放进同一个结构体。",
                "自定义 sort 比较规则，按总分、语文、编号依次比较。",
                "注意 n 可能小于 5。"
            ],
            answer: "核心思路：建立 Student(id, chinese, math, english, total)，排序时先比较 total 降序，再比较 chinese 降序，最后比较 id 升序。输出 min(5, n) 行。",
            commonTrap: "只按总分排序会在同分数据上 WA；输出固定 5 行会在 n < 5 时越界。"
        ),
        PracticeProblem(
            id: "math-001",
            title: "最大公约数与约分",
            topic: .math,
            difficulty: .starter,
            estimatedMinutes: 12,
            tags: ["gcd", "辗转相除", "分数"],
            prompt: "输入两个正整数 a, b，表示分数 a/b。输出约分后的分子和分母。",
            hints: [
                "使用辗转相除法求 gcd(a, b)。",
                "分子分母同时除以最大公约数。"
            ],
            answer: "g = gcd(a, b)，输出 a / g 和 b / g。C++17 可以用 std::gcd，也可以自己写 while (b) { t = a % b; a = b; b = t; }。",
            commonTrap: "把最小公倍数当成约分依据，或忘记处理 a 与 b 已经互质的情况。"
        ),
        PracticeProblem(
            id: "search-001",
            title: "迷宫最短路",
            topic: .graph,
            difficulty: .standard,
            estimatedMinutes: 28,
            tags: ["BFS", "队列", "最短路"],
            prompt: "给定 n*m 的迷宫，'.' 可走，'#' 为墙，S 为起点，T 为终点。每次上下左右走一步，求从 S 到 T 的最少步数；不可达输出 -1。",
            hints: [
                "无权图最短路优先考虑 BFS。",
                "队列里保存坐标和当前距离，或者用 dist 数组。",
                "入队时立刻标记，避免重复入队。"
            ],
            answer: "从 S 开始 BFS，dist[S] = 0。每次弹出一个格子，枚举四个方向，合法且未访问则 dist[next] = dist[cur] + 1 并入队。最后输出 dist[T]，未访问为 -1。",
            commonTrap: "出队时才标记会导致同一个点被多次入队；把 n、m 行列写反会造成隐藏数据错误。"
        ),
        PracticeProblem(
            id: "dp-001",
            title: "数字三角形",
            topic: .dp,
            difficulty: .standard,
            estimatedMinutes: 25,
            tags: ["线性 DP", "状态转移", "滚动数组"],
            prompt: "给出一个 n 层数字三角形，从顶部走到底部，每次只能走到下一层相邻位置，求路径数字和最大值。",
            hints: [
                "状态可以定义为 dp[i][j]：走到第 i 层第 j 个数的最大和。",
                "转移来自上一层的 j-1 或 j。",
                "边界位置只有一个来源。"
            ],
            answer: "dp[i][j] = max(dp[i - 1][j - 1], dp[i - 1][j]) + a[i][j]，边界单独处理。答案是最后一层 dp 的最大值。",
            commonTrap: "初始化为 0 会影响存在负数的版本；更稳妥是初始化为一个很小的负数。"
        ),
        PracticeProblem(
            id: "string-001",
            title: "回文串判定",
            topic: .strings,
            difficulty: .starter,
            estimatedMinutes: 10,
            tags: ["双指针", "字符串"],
            prompt: "输入一个只包含小写字母的字符串，判断它是否为回文串。",
            hints: [
                "使用 l = 0, r = s.length - 1。",
                "每轮比较 s[l] 与 s[r]，相同则向中间移动。"
            ],
            answer: "双指针从两端向中间扫描，任意一对字符不同就输出 No；扫描完成输出 Yes。",
            commonTrap: "循环条件写成 l <= r 没错但多比较一次；真正容易错的是下标使用 1-based 与 0-based 混在一起。"
        ),
        PracticeProblem(
            id: "dp-002",
            title: "01 背包",
            topic: .dp,
            difficulty: .challenge,
            estimatedMinutes: 35,
            tags: ["背包 DP", "倒序枚举", "优化"],
            prompt: "有 n 件物品和容量为 V 的背包，每件物品有体积 w[i] 和价值 v[i]，每件最多选一次。求最大价值。",
            hints: [
                "一维 dp[j] 表示容量不超过 j 的最大价值。",
                "每件物品只能选一次，所以容量要从 V 倒序枚举到 w[i]。",
                "如果正序枚举，会变成完全背包。"
            ],
            answer: "for item in items { for j from V downTo w[item] { dp[j] = max(dp[j], dp[j - w[item]] + value[item]) } }，答案为 dp[V]。",
            commonTrap: "容量正序枚举会让同一物品被重复选，样例可能过，正式数据会错。"
        ),
        PracticeProblem(
            id: "graph-002",
            title: "连通块数量",
            topic: .graph,
            difficulty: .standard,
            estimatedMinutes: 22,
            tags: ["DFS", "图遍历", "邻接表"],
            prompt: "给定 n 个点 m 条无向边，求图中连通块的数量。",
            hints: [
                "用邻接表存图。",
                "从每个未访问点出发 DFS 或 BFS。",
                "每启动一次新的遍历，连通块计数加一。"
            ],
            answer: "遍历 1...n，若点 i 未访问，则 ans += 1，并从 i 开始 DFS/BFS 标记所有可达点。输出 ans。",
            commonTrap: "只从 1 号点搜索会漏掉其他连通块；无向边需要双向加边。"
        ),
        PracticeProblem(
            id: "math-002",
            title: "质数筛",
            topic: .math,
            difficulty: .challenge,
            estimatedMinutes: 30,
            tags: ["埃氏筛", "复杂度", "素数"],
            prompt: "输入 n，输出 1 到 n 中所有质数的数量。",
            hints: [
                "n 较大时不能对每个数试除到 sqrt(x)。",
                "使用 isPrime 数组，先全部设为 true，再筛掉合数。",
                "从 i*i 开始筛可以减少重复。"
            ],
            answer: "埃氏筛：isPrime[0] = isPrime[1] = false。对 i 从 2 到 sqrt(n)，若 isPrime[i]，则把 i*i, i*i+i... 标记为 false。最后统计 true 的数量。",
            commonTrap: "i*i 可能溢出 int，n 很大时用 long long 判断；1 不是质数。"
        )
    ]

    static let references: [ReferenceArticle] = [
        ReferenceArticle(
            id: "cpp-template",
            title: "C++17 考场模板",
            subtitle: "输入输出、常用容器、排序比较器和调试习惯",
            topic: .basics,
            readingMinutes: 6,
            bullets: [
                "开头常用 #include <bits/stdc++.h> 与 using namespace std。",
                "大数据读入可以加 ios::sync_with_stdio(false); cin.tie(nullptr);。",
                "vector、queue、stack、set、map 是初中组常见够用工具。",
                "比较器要写清楚同分规则，避免靠默认排序猜结果。"
            ]
        ),
        ReferenceArticle(
            id: "bfs-dfs",
            title: "DFS 与 BFS 怎么选",
            subtitle: "搜索题最常见的分岔口",
            topic: .graph,
            readingMinutes: 7,
            bullets: [
                "求是否可达、枚举方案、连通块，DFS/BFS 都可以。",
                "求无权图最短步数，优先 BFS。",
                "递归 DFS 要注意深度，数据大时可改成栈或 BFS。",
                "网格题先写方向数组，再统一做边界判断。"
            ]
        ),
        ReferenceArticle(
            id: "dp-thinking",
            title: "DP 四步法",
            subtitle: "从状态定义到边界初始化",
            topic: .dp,
            readingMinutes: 8,
            bullets: [
                "定义状态：dp 数组每个位置到底表示什么。",
                "找转移：当前状态可以从哪些已知状态来。",
                "定顺序：保证转移来源已经算过。",
                "查边界：第一行、第一列、容量为 0、空串等情况。"
            ]
        ),
        ReferenceArticle(
            id: "exam-rhythm",
            title: "考场时间分配",
            subtitle: "先拿稳分，再冲提高题",
            topic: .simulation,
            readingMinutes: 5,
            bullets: [
                "先通读题面，标记会做、半会、没思路。",
                "简单题 20 分钟仍卡住就先跳过。",
                "写完一题立刻造 2 到 3 组边界数据自测。",
                "最后 15 分钟优先检查数组越界、long long、文件名或输入格式。"
            ]
        )
    ]

    static let pitfalls: [PitfallGuide] = [
        PitfallGuide(
            id: "overflow",
            title: "int 爆了但样例没爆",
            symptom: "样例答案正确，提交后大数据 WA，尤其是乘法、路径数、前缀和题。",
            fix: "看到 10^5、10^9、求和、乘积、方案数，先考虑 long long。",
            checklist: [
                "乘法前把变量转成 long long。",
                "前缀和数组用 long long。",
                "比较 i*i <= n 时注意 i*i 溢出。"
            ]
        ),
        PitfallGuide(
            id: "index",
            title: "下标从 0 还是 1 开始",
            symptom: "本地跑小样例正常，换一组边界数据就崩或答案差一点。",
            fix: "整题统一一种下标风格；如果题面编号从 1 开始，数组也可以开 n + 1。",
            checklist: [
                "循环范围和数组大小匹配。",
                "字符串一般按 0-based 处理。",
                "网格输入时确认行是 i，列是 j。"
            ]
        ),
        PitfallGuide(
            id: "sort-rule",
            title: "排序同分规则漏写",
            symptom: "排序题样例过了，隐藏测试错在多个关键字相同的情况。",
            fix: "把题面中的每一句“若相同则...”都翻译进比较器。",
            checklist: [
                "降序和升序不要写反。",
                "最后一个兜底规则通常是编号小者优先。",
                "比较器不要在完全相等时返回 true。"
            ]
        ),
        PitfallGuide(
            id: "bfs-visited",
            title: "BFS 重复入队",
            symptom: "答案可能正确，但运行慢、内存变大，复杂迷宫会超时。",
            fix: "一个点准备入队时就标记 visited，而不是出队后再标记。",
            checklist: [
                "dist 初始化为 -1 可以兼当 visited。",
                "只访问合法、可走、未访问的格子。",
                "方向数组 dx/dy 顺序保持一致。"
            ]
        )
    ]

    static let studyPlan: [StudyDay] = [
        StudyDay(day: "周一", focus: "语法与模拟", tasks: ["复盘数组、字符串、结构体", "完成 2 道排序或模拟题"]),
        StudyDay(day: "周二", focus: "数学基础", tasks: ["练 gcd、质数、取模", "整理错题里的边界条件"]),
        StudyDay(day: "周三", focus: "搜索", tasks: ["写一遍 DFS/BFS 模板", "完成 1 道迷宫题"]),
        StudyDay(day: "周四", focus: "动态规划", tasks: ["理解状态定义", "完成数字三角形或背包入门题"]),
        StudyDay(day: "周五", focus: "限时训练", tasks: ["45 分钟完成 2 道题", "记录卡住的位置"]),
        StudyDay(day: "周末", focus: "复盘与补漏", tasks: ["重做本周错题", "更新自己的考前检查清单"])
    ]

    static let finalChecklist: [String] = [
        "确认输入格式：多组数据、行列顺序、是否有空格或换行。",
        "检查数组大小：n + 5、m + 5，图的边数组是否够大。",
        "所有求和、乘法、路径数先想 long long。",
        "排序比较器覆盖所有同分规则，完全相等时返回 false。",
        "BFS 入队时标记，DFS 注意递归深度。",
        "DP 初始化不能偷懒，特别是负数、不可达状态和容量为 0。",
        "至少造一组最小数据、一组最大边界、一组特殊同分或不可达数据。",
        "提交前删除调试输出，确认输出大小写和标点。"
    ]
}
