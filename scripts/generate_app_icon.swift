import AppKit

struct IconTheme {
    let topColor: NSColor
    let bottomColor: NSColor
    let cardColor: NSColor
    let accentColor: NSColor
    let textColor: NSColor
    let shadowColor: NSColor
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputDirectory = root
    .appendingPathComponent("信息奥赛练习大全-信奥准备-标准题型")
    .appendingPathComponent("Assets.xcassets")
    .appendingPathComponent("AppIcon.appiconset")

let regularTheme = IconTheme(
    topColor: NSColor(calibratedRed: 0.05, green: 0.26, blue: 0.72, alpha: 1),
    bottomColor: NSColor(calibratedRed: 0.01, green: 0.70, blue: 0.63, alpha: 1),
    cardColor: NSColor(calibratedWhite: 1, alpha: 0.92),
    accentColor: NSColor(calibratedRed: 1.00, green: 0.76, blue: 0.19, alpha: 1),
    textColor: NSColor(calibratedRed: 0.05, green: 0.16, blue: 0.35, alpha: 1),
    shadowColor: NSColor(calibratedWhite: 0, alpha: 0.22)
)

let darkTheme = IconTheme(
    topColor: NSColor(calibratedRed: 0.02, green: 0.05, blue: 0.15, alpha: 1),
    bottomColor: NSColor(calibratedRed: 0.00, green: 0.26, blue: 0.35, alpha: 1),
    cardColor: NSColor(calibratedRed: 0.13, green: 0.19, blue: 0.31, alpha: 1),
    accentColor: NSColor(calibratedRed: 0.49, green: 0.85, blue: 1.00, alpha: 1),
    textColor: NSColor(calibratedWhite: 1, alpha: 1),
    shadowColor: NSColor(calibratedWhite: 0, alpha: 0.45)
)

let tintedTheme = IconTheme(
    topColor: NSColor(calibratedWhite: 0.18, alpha: 1),
    bottomColor: NSColor(calibratedWhite: 0.58, alpha: 1),
    cardColor: NSColor(calibratedWhite: 0.96, alpha: 0.94),
    accentColor: NSColor(calibratedWhite: 0.25, alpha: 1),
    textColor: NSColor(calibratedWhite: 0.10, alpha: 1),
    shadowColor: NSColor(calibratedWhite: 0, alpha: 0.18)
)

func roundedRect(_ rect: NSRect, radius: CGFloat) -> NSBezierPath {
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
}

func drawGradient(in rect: NSRect, theme: IconTheme) {
    guard let context = NSGraphicsContext.current?.cgContext else { return }
    let colors = [theme.topColor.cgColor, theme.bottomColor.cgColor] as CFArray
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1]) else { return }
    context.drawLinearGradient(
        gradient,
        start: CGPoint(x: rect.midX - 180, y: rect.maxY),
        end: CGPoint(x: rect.midX + 220, y: rect.minY),
        options: []
    )
}

func drawIcon(named filename: String, theme: IconTheme) {
    let size = NSSize(width: 1024, height: 1024)
    let image = NSImage(size: size)

    image.lockFocus()
    let canvas = NSRect(origin: .zero, size: size)
    drawGradient(in: canvas, theme: theme)

    theme.shadowColor.setFill()
    roundedRect(NSRect(x: 212, y: 206, width: 600, height: 590), radius: 92).fill()

    theme.cardColor.setFill()
    roundedRect(NSRect(x: 190, y: 236, width: 600, height: 590), radius: 92).fill()

    NSColor(calibratedWhite: 1, alpha: 0.36).setStroke()
    let grid = NSBezierPath()
    grid.lineWidth = 9
    for x in stride(from: 270, through: 710, by: 110) {
        grid.move(to: NSPoint(x: x, y: 296))
        grid.line(to: NSPoint(x: x, y: 746))
    }
    for y in stride(from: 326, through: 706, by: 95) {
        grid.move(to: NSPoint(x: 240, y: y))
        grid.line(to: NSPoint(x: 740, y: y))
    }
    grid.stroke()

    theme.textColor.setStroke()
    let leftBrace = NSBezierPath()
    leftBrace.lineWidth = 42
    leftBrace.lineCapStyle = .round
    leftBrace.lineJoinStyle = .round
    leftBrace.move(to: NSPoint(x: 378, y: 666))
    leftBrace.curve(to: NSPoint(x: 326, y: 570), controlPoint1: NSPoint(x: 314, y: 650), controlPoint2: NSPoint(x: 326, y: 606))
    leftBrace.curve(to: NSPoint(x: 268, y: 512), controlPoint1: NSPoint(x: 326, y: 538), controlPoint2: NSPoint(x: 296, y: 522))
    leftBrace.curve(to: NSPoint(x: 326, y: 454), controlPoint1: NSPoint(x: 296, y: 502), controlPoint2: NSPoint(x: 326, y: 486))
    leftBrace.curve(to: NSPoint(x: 378, y: 358), controlPoint1: NSPoint(x: 326, y: 418), controlPoint2: NSPoint(x: 314, y: 374))
    leftBrace.stroke()

    let rightBrace = NSBezierPath()
    rightBrace.lineWidth = 42
    rightBrace.lineCapStyle = .round
    rightBrace.lineJoinStyle = .round
    rightBrace.move(to: NSPoint(x: 646, y: 666))
    rightBrace.curve(to: NSPoint(x: 698, y: 570), controlPoint1: NSPoint(x: 710, y: 650), controlPoint2: NSPoint(x: 698, y: 606))
    rightBrace.curve(to: NSPoint(x: 756, y: 512), controlPoint1: NSPoint(x: 698, y: 538), controlPoint2: NSPoint(x: 728, y: 522))
    rightBrace.curve(to: NSPoint(x: 698, y: 454), controlPoint1: NSPoint(x: 728, y: 502), controlPoint2: NSPoint(x: 698, y: 486))
    rightBrace.curve(to: NSPoint(x: 646, y: 358), controlPoint1: NSPoint(x: 698, y: 418), controlPoint2: NSPoint(x: 710, y: 374))
    rightBrace.stroke()

    theme.accentColor.setFill()
    roundedRect(NSRect(x: 406, y: 398, width: 212, height: 212), radius: 48).fill()

    theme.textColor.setStroke()
    let check = NSBezierPath()
    check.lineWidth = 34
    check.lineCapStyle = .round
    check.lineJoinStyle = .round
    check.move(to: NSPoint(x: 452, y: 505))
    check.line(to: NSPoint(x: 498, y: 458))
    check.line(to: NSPoint(x: 586, y: 558))
    check.stroke()

    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    let font = NSFont(name: "PingFangSC-Semibold", size: 112) ?? NSFont.systemFont(ofSize: 112, weight: .bold)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: theme.textColor,
        .paragraphStyle: paragraph
    ]
    NSString(string: "信奥").draw(in: NSRect(x: 250, y: 244, width: 524, height: 144), withAttributes: attributes)

    image.unlockFocus()

    guard let data = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: data),
          let png = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Could not create PNG data")
    }

    let destination = outputDirectory.appendingPathComponent(filename)
    try! png.write(to: destination)
    flattenPNGWithSips(destination)
}

func run(_ launchPath: String, _ arguments: [String]) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: launchPath)
    process.arguments = arguments
    try! process.run()
    process.waitUntilExit()
    guard process.terminationStatus == 0 else {
        fatalError("\(launchPath) failed with status \(process.terminationStatus)")
    }
}

func flattenPNGWithSips(_ pngURL: URL) {
    let jpgURL = pngURL.deletingPathExtension().appendingPathExtension("flatten.jpg")
    run("/usr/bin/sips", ["-s", "format", "jpeg", pngURL.path, "--out", jpgURL.path])
    run("/usr/bin/sips", ["-s", "format", "png", jpgURL.path, "--out", pngURL.path])
    try? FileManager.default.removeItem(at: jpgURL)
}

try! FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
drawIcon(named: "AppIcon-1024.png", theme: regularTheme)
drawIcon(named: "AppIcon-Dark-1024.png", theme: darkTheme)
drawIcon(named: "AppIcon-Tinted-1024.png", theme: tintedTheme)
