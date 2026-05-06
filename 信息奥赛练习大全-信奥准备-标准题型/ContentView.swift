import Combine
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab

    init() {
        ScreenshotMode.prepareDefaultsIfNeeded()
        _selectedTab = State(initialValue: ScreenshotMode.initialTab)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("今日", systemImage: "calendar.badge.clock")
                }
                .tag(AppTab.dashboard)

            PracticeView()
                .tabItem {
                    Label("练题", systemImage: "checklist.checked")
                }
                .tag(AppTab.practice)

            ReviewView()
                .tabItem {
                    Label("复盘", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(AppTab.review)

            ReferenceView()
                .tabItem {
                    Label("资料", systemImage: "books.vertical")
                }
                .tag(AppTab.reference)

            PitfallView()
                .tabItem {
                    Label("避坑", systemImage: "exclamationmark.triangle")
                }
                .tag(AppTab.pitfall)
        }
        .tint(.blue)
        .statusBarHidden(ScreenshotMode.isEnabled)
    }
}

private enum AppTab: String {
    case dashboard
    case practice
    case review
    case reference
    case pitfall
}

private enum ScreenshotMode {
    static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT")
            || UserDefaults.standard.bool(forKey: "ScreenshotMode")
    }

    static var initialTab: AppTab {
        guard isEnabled,
              let rawValue = UserDefaults.standard.string(forKey: "ScreenshotTab"),
              let tab = AppTab(rawValue: rawValue)
        else {
            return .dashboard
        }
        return tab
    }

    static func prepareDefaultsIfNeeded() {
        guard isEnabled else { return }

        let defaults = UserDefaults.standard
        defaults.set("sim-001,math-001,search-001,dp-001", forKey: "completedProblemIDs")
        defaults.set("dp-001,string-001", forKey: "starredProblemIDs")
        defaults.set(
            "二分先写清楚边界含义；图论题先确认是否有重边、自环和连通性。",
            forKey: "problemNote-dp-001"
        )
    }
}

private struct DashboardView: View {
    @AppStorage("completedProblemIDs") private var completedProblemIDs = ""
    @AppStorage("starredProblemIDs") private var starredProblemIDs = ""

    private let columns = [GridItem(.adaptive(minimum: 154), spacing: 12)]

    private var completedSet: Set<String> {
        Set(completedProblemIDs.split(separator: ",").map(String.init))
    }

    private var starredSet: Set<String> {
        Set(starredProblemIDs.split(separator: ",").map(String.init))
    }

    private var completionRatio: Double {
        guard !OlympiadLibrary.problems.isEmpty else { return 0 }
        return Double(completedSet.count) / Double(OlympiadLibrary.problems.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderPanel()

                    ProgressSummaryPanel(
                        completedCount: completedSet.count,
                        totalCount: OlympiadLibrary.problems.count,
                        starredCount: starredSet.count,
                        completionRatio: completionRatio
                    )

                    LazyVGrid(columns: columns, spacing: 12) {
                        MetricTile(
                            title: "题库",
                            value: "\(OlympiadLibrary.problems.count)",
                            note: "覆盖初赛到提高常见题型",
                            symbolName: "square.grid.2x2",
                            tint: .blue
                        )
                        MetricTile(
                            title: "资料",
                            value: "\(OlympiadLibrary.references.count)",
                            note: "模板、思路、考场节奏",
                            symbolName: "doc.text.magnifyingglass",
                            tint: .green
                        )
                        MetricTile(
                            title: "避坑",
                            value: "\(OlympiadLibrary.pitfalls.count)",
                            note: "隐藏测试常见失分点",
                            symbolName: "wrench.and.screwdriver",
                            tint: .orange
                        )
                    }

                    SectionHeading(title: "本周训练节奏", subtitle: "每天少量稳定推进，周末集中复盘。")

                    VStack(spacing: 10) {
                        ForEach(OlympiadLibrary.studyPlan) { day in
                            StudyDayRow(day: day)
                        }
                    }

                    SectionHeading(title: "题型地图", subtitle: "先补短板，再做限时混合训练。")

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Topic.allCases) { topic in
                            TopicTile(topic: topic)
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("信奥备赛")
        }
    }
}

private struct HeaderPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("信息奥赛练习大全")
                        .font(.title2.bold())
                    Text("面向深圳初中生的离线练习、资料速查和考前避坑清单。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "laptopcomputer.and.iphone")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .accessibilityHidden(true)
            }

            HStack(spacing: 8) {
                Label("C++17", systemImage: "curlybraces")
                Label("NOI 风格", systemImage: "flag.checkered")
                Label("错题复盘", systemImage: "arrow.counterclockwise")
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    let note: String
    let symbolName: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbolName)
                .font(.title3)
                .foregroundStyle(tint)
                .accessibilityHidden(true)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.headline)
            Text(note)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ProgressSummaryPanel: View {
    let completedCount: Int
    let totalCount: Int
    let starredCount: Int
    let completionRatio: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color(.secondarySystemGroupedBackground), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: completionRatio)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(completionRatio * 100))%")
                        .font(.headline.bold())
                }
                .frame(width: 74, height: 74)
                .accessibilityLabel("完成进度 \(Int(completionRatio * 100))%")

                VStack(alignment: .leading, spacing: 6) {
                    Text("今日继续稳住节奏")
                        .font(.headline)
                    Text("已完成 \(completedCount)/\(totalCount) 道题，收藏 \(starredCount) 道需要复盘的题。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            ProgressView(value: completionRatio)
                .tint(.blue)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SectionHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct StudyDayRow: View {
    let day: StudyDay

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(day.day)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.blue, in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                Text(day.focus)
                    .font(.headline)
                ForEach(day.tasks, id: \.self) { task in
                    Label(task, systemImage: "checkmark.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct TopicTile: View {
    let topic: Topic

    private var problemCount: Int {
        OlympiadLibrary.problems.filter { $0.topic == topic }.count
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: topic.symbolName)
                .foregroundStyle(.blue)
                .frame(width: 28, height: 28)
                .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(topic.rawValue)
                    .font(.subheadline.weight(.semibold))
                Text("\(problemCount) 道练习")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct PracticeView: View {
    @AppStorage("completedProblemIDs") private var completedProblemIDs = ""
    @AppStorage("starredProblemIDs") private var starredProblemIDs = ""
    @State private var searchText = ""
    @State private var selectedTopic: Topic?
    @State private var selectedDifficulty: Difficulty?

    private var completedSet: Set<String> {
        Set(completedProblemIDs.split(separator: ",").map(String.init))
    }

    private var starredSet: Set<String> {
        Set(starredProblemIDs.split(separator: ",").map(String.init))
    }

    private var filteredProblems: [PracticeProblem] {
        OlympiadLibrary.problems.filter { problem in
            let matchesTopic = selectedTopic == nil || problem.topic == selectedTopic
            let matchesDifficulty = selectedDifficulty == nil || problem.difficulty == selectedDifficulty
            let matchesSearch = searchText.isEmpty
                || problem.title.localizedStandardContains(searchText)
                || problem.tags.contains { $0.localizedStandardContains(searchText) }
                || problem.prompt.localizedStandardContains(searchText)
            return matchesTopic && matchesDifficulty && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    FilterPanel(
                        selectedTopic: $selectedTopic,
                        selectedDifficulty: $selectedDifficulty
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section {
                    ForEach(filteredProblems) { problem in
                        NavigationLink {
                            ProblemDetailView(
                                problem: problem,
                                isCompleted: completedSet.contains(problem.id),
                                isStarred: starredSet.contains(problem.id),
                                toggleCompleted: { toggleCompleted(problem.id) },
                                toggleStarred: { toggleStarred(problem.id) }
                            )
                        } label: {
                            ProblemRow(
                                problem: problem,
                                isCompleted: completedSet.contains(problem.id),
                                isStarred: starredSet.contains(problem.id)
                            )
                        }
                    }
                } header: {
                    Text("练习题 \(filteredProblems.count)")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("练题")
            .searchable(text: $searchText, prompt: "搜索题目、标签或题面")
        }
    }

    private func toggleCompleted(_ id: String) {
        var ids = completedSet
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        completedProblemIDs = ids.sorted().joined(separator: ",")
    }

    private func toggleStarred(_ id: String) {
        var ids = starredSet
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        starredProblemIDs = ids.sorted().joined(separator: ",")
    }
}

private struct FilterPanel: View {
    @Binding var selectedTopic: Topic?
    @Binding var selectedDifficulty: Difficulty?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("题型")
                    .font(.subheadline.weight(.semibold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "全部", isSelected: selectedTopic == nil) {
                            selectedTopic = nil
                        }
                        ForEach(Topic.allCases) { topic in
                            FilterChip(title: topic.rawValue, isSelected: selectedTopic == topic) {
                                selectedTopic = topic
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("难度")
                    .font(.subheadline.weight(.semibold))
                HStack(spacing: 8) {
                    FilterChip(title: "全部", isSelected: selectedDifficulty == nil) {
                        selectedDifficulty = nil
                    }
                    ForEach(Difficulty.allCases) { difficulty in
                        FilterChip(title: difficulty.rawValue, isSelected: selectedDifficulty == difficulty) {
                            selectedDifficulty = difficulty
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? .white : .primary)
                .background(isSelected ? Color.blue : Color(.secondarySystemGroupedBackground), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct ProblemRow: View {
    let problem: PracticeProblem
    let isCompleted: Bool
    let isStarred: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : problem.topic.symbolName)
                    .foregroundStyle(isCompleted ? .green : .blue)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(problem.title)
                        .font(.headline)
                    Text(problem.prompt)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                if isStarred {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .accessibilityLabel("已收藏")
                }
            }

            HStack(spacing: 8) {
                Label("\(problem.estimatedMinutes) 分钟", systemImage: "clock")
                Text(problem.topic.rawValue)
                Text(problem.difficulty.rawValue)
                    .foregroundStyle(problem.difficulty.tint)
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

private struct ProblemDetailView: View {
    let problem: PracticeProblem
    let isCompleted: Bool
    let isStarred: Bool
    let toggleCompleted: () -> Void
    let toggleStarred: () -> Void

    @State private var showsHints = false
    @State private var showsAnswer = false
    @State private var noteText = ""

    private var noteKey: String {
        "problemNote-\(problem.id)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label(problem.topic.rawValue, systemImage: problem.topic.symbolName)
                        Spacer()
                        Text(problem.difficulty.rawValue)
                            .foregroundStyle(problem.difficulty.tint)
                    }
                    .font(.subheadline.weight(.medium))

                    Text(problem.title)
                        .font(.title2.bold())

                    HStack(spacing: 8) {
                        ForEach(problem.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Color(.secondarySystemGroupedBackground), in: Capsule())
                        }
                    }
                }

                ContentBlock(title: "题面", symbolName: "doc.plaintext") {
                    Text(problem.prompt)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button {
                    showsHints.toggle()
                } label: {
                    Label(showsHints ? "收起提示" : "查看提示", systemImage: "lightbulb")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                if showsHints {
                    ContentBlock(title: "提示", symbolName: "lightbulb.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(problem.hints.enumerated()), id: \.offset) { index, hint in
                                Text("\(index + 1). \(hint)")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                Button {
                    showsAnswer.toggle()
                } label: {
                    Label(showsAnswer ? "隐藏参考思路" : "查看参考思路", systemImage: "eye")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if showsAnswer {
                    ContentBlock(title: "参考思路", symbolName: "checkmark.seal") {
                        Text(problem.answer)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    ContentBlock(title: "易错点", symbolName: "exclamationmark.triangle") {
                        Text(problem.commonTrap)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                ContentBlock(title: "我的笔记", symbolName: "pencil.and.list.clipboard") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 120)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                }

                Button(action: toggleCompleted) {
                    Label(isCompleted ? "标记为未完成" : "标记为已完成", systemImage: isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("题目详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: toggleStarred) {
                Image(systemName: isStarred ? "star.fill" : "star")
            }
            .accessibilityLabel(isStarred ? "取消收藏" : "收藏题目")
        }
        .onAppear {
            noteText = UserDefaults.standard.string(forKey: noteKey) ?? ""
        }
        .onChange(of: noteText) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: noteKey)
        }
    }
}

private struct ContentBlock<Content: View>: View {
    let title: String
    let symbolName: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: symbolName)
                .font(.headline)
            content
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ReviewView: View {
    @AppStorage("completedProblemIDs") private var completedProblemIDs = ""
    @AppStorage("starredProblemIDs") private var starredProblemIDs = ""

    private var completedSet: Set<String> {
        Set(completedProblemIDs.split(separator: ",").map(String.init))
    }

    private var starredSet: Set<String> {
        Set(starredProblemIDs.split(separator: ",").map(String.init))
    }

    private var starredProblems: [PracticeProblem] {
        OlympiadLibrary.problems.filter { starredSet.contains($0.id) }
    }

    private var unfinishedProblems: [PracticeProblem] {
        OlympiadLibrary.problems.filter { !completedSet.contains($0.id) }
    }

    private var weakTopics: [(topic: Topic, remaining: Int)] {
        Topic.allCases
            .map { topic in
                let remaining = OlympiadLibrary.problems.filter {
                    $0.topic == topic && !completedSet.contains($0.id)
                }.count
                return (topic, remaining)
            }
            .filter { $0.remaining > 0 }
            .sorted { $0.remaining > $1.remaining }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ReviewProgressCard(
                        completedCount: completedSet.count,
                        totalCount: OlympiadLibrary.problems.count,
                        starredCount: starredSet.count
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section {
                    SprintTimerCard()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section("薄弱题型") {
                    if weakTopics.isEmpty {
                        EmptyStateRow(symbolName: "checkmark.seal", title: "题型都练过了", subtitle: "可以开始限时混合训练。")
                    } else {
                        ForEach(weakTopics, id: \.topic.id) { item in
                            HStack {
                                Label(item.topic.rawValue, systemImage: item.topic.symbolName)
                                Spacer()
                                Text("剩 \(item.remaining)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("收藏复盘") {
                    if starredProblems.isEmpty {
                        EmptyStateRow(symbolName: "star", title: "还没有收藏题", subtitle: "在题目详情右上角点星标，难题会出现在这里。")
                    } else {
                        ForEach(starredProblems) { problem in
                            NavigationLink {
                                ProblemDetailView(
                                    problem: problem,
                                    isCompleted: completedSet.contains(problem.id),
                                    isStarred: starredSet.contains(problem.id),
                                    toggleCompleted: { toggleCompleted(problem.id) },
                                    toggleStarred: { toggleStarred(problem.id) }
                                )
                            } label: {
                                ProblemRow(
                                    problem: problem,
                                    isCompleted: completedSet.contains(problem.id),
                                    isStarred: starredSet.contains(problem.id)
                                )
                            }
                        }
                    }
                }

                Section("下一批建议") {
                    ForEach(Array(unfinishedProblems.prefix(3))) { problem in
                        NavigationLink {
                            ProblemDetailView(
                                problem: problem,
                                isCompleted: completedSet.contains(problem.id),
                                isStarred: starredSet.contains(problem.id),
                                toggleCompleted: { toggleCompleted(problem.id) },
                                toggleStarred: { toggleStarred(problem.id) }
                            )
                        } label: {
                            ProblemRow(
                                problem: problem,
                                isCompleted: completedSet.contains(problem.id),
                                isStarred: starredSet.contains(problem.id)
                            )
                        }
                    }
                }

                Section("考前检查") {
                    ForEach(OlympiadLibrary.finalChecklist, id: \.self) { item in
                        Label {
                            Text(item)
                                .fixedSize(horizontal: false, vertical: true)
                        } icon: {
                            Image(systemName: "checkmark.square")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("复盘")
        }
    }

    private func toggleCompleted(_ id: String) {
        var ids = completedSet
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        completedProblemIDs = ids.sorted().joined(separator: ",")
    }

    private func toggleStarred(_ id: String) {
        var ids = starredSet
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        starredProblemIDs = ids.sorted().joined(separator: ",")
    }
}

private struct SprintTimerCard: View {
    @State private var selectedMinutes = 45
    @State private var remainingSeconds = 45 * 60
    @State private var isRunning = false

    private let options = [15, 30, 45]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var totalSeconds: Int {
        selectedMinutes * 60
    }

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    private var timeText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("限时训练")
                        .font(.headline)
                    Text("选一组时间，专注做题，到点立刻复盘。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(timeText)
                    .font(.system(.title2, design: .monospaced).bold())
            }

            Picker("训练时长", selection: $selectedMinutes) {
                ForEach(options, id: \.self) { minutes in
                    Text("\(minutes) 分").tag(minutes)
                }
            }
            .pickerStyle(.segmented)

            ProgressView(value: progress)
                .tint(isRunning ? .green : .blue)

            HStack(spacing: 10) {
                Button {
                    isRunning.toggle()
                } label: {
                    Label(isRunning ? "暂停" : "开始", systemImage: isRunning ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    reset()
                } label: {
                    Label("重置", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                isRunning = false
            }
        }
        .onChange(of: selectedMinutes) { _, _ in
            guard !isRunning else { return }
            reset()
        }
    }

    private func reset() {
        isRunning = false
        remainingSeconds = selectedMinutes * 60
    }
}

private struct ReviewProgressCard: View {
    let completedCount: Int
    let totalCount: Int
    let starredCount: Int

    private var ratio: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("训练进度")
                        .font(.headline)
                    Text("完成 \(completedCount) 道，未完成 \(max(totalCount - completedCount, 0)) 道。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Label("\(starredCount)", systemImage: "star.fill")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            }

            ProgressView(value: ratio)
                .tint(.blue)

            Text("建议每天至少完成 1 道新题，再复盘 1 道收藏题。")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct EmptyStateRow: View {
    let symbolName: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbolName)
                .foregroundStyle(.secondary)
                .frame(width: 28)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 6)
    }
}

private struct ReferenceView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(OlympiadLibrary.references) { article in
                    NavigationLink {
                        ReferenceDetailView(article: article)
                    } label: {
                        ReferenceRow(article: article)
                    }
                }
            }
            .navigationTitle("资料")
        }
    }
}

private struct ReferenceRow: View {
    let article: ReferenceArticle

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: article.topic.symbolName)
                .foregroundStyle(.green)
                .frame(width: 30, height: 30)
                .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title)
                    .font(.headline)
                Text(article.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Label("\(article.readingMinutes) 分钟", systemImage: "timer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

private struct ReferenceDetailView: View {
    let article: ReferenceArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(article.topic.rawValue, systemImage: article.topic.symbolName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.green)
                    Text(article.title)
                        .font(.title2.bold())
                    Text(article.subtitle)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(article.bullets, id: \.self) { bullet in
                        Label {
                            Text(bullet)
                                .fixedSize(horizontal: false, vertical: true)
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
                .padding(14)
                .background(.background, in: RoundedRectangle(cornerRadius: 8))
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("资料详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PitfallView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("提交前从这里过一遍，很多失分不是不会做，而是细节没有守住。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(OlympiadLibrary.pitfalls) { guide in
                    NavigationLink {
                        PitfallDetailView(guide: guide)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(guide.title)
                                .font(.headline)
                            Text(guide.symptom)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("避坑")
        }
    }
}

private struct PitfallDetailView: View {
    let guide: PitfallGuide

    @State private var checkedItems: Set<String> = []

    private var storageKey: String {
        "pitfallChecklist-\(guide.id)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(guide.title)
                    .font(.title2.bold())

                ContentBlock(title: "常见表现", symbolName: "waveform.path.ecg") {
                    Text(guide.symptom)
                        .fixedSize(horizontal: false, vertical: true)
                }

                ContentBlock(title: "修法", symbolName: "wrench.adjustable") {
                    Text(guide.fix)
                        .fixedSize(horizontal: false, vertical: true)
                }

                ContentBlock(title: "提交前检查", symbolName: "checklist") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(guide.checklist, id: \.self) { item in
                            Button {
                                toggle(item)
                            } label: {
                                Label {
                                    Text(item)
                                        .fixedSize(horizontal: false, vertical: true)
                                } icon: {
                                    Image(systemName: checkedItems.contains(item) ? "checkmark.square.fill" : "square")
                                        .foregroundStyle(checkedItems.contains(item) ? .green : .secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("避坑详情")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkedItems = Set((UserDefaults.standard.array(forKey: storageKey) as? [String]) ?? [])
        }
    }

    private func toggle(_ item: String) {
        if checkedItems.contains(item) {
            checkedItems.remove(item)
        } else {
            checkedItems.insert(item)
        }
        UserDefaults.standard.set(Array(checkedItems).sorted(), forKey: storageKey)
    }
}

#Preview {
    ContentView()
}
