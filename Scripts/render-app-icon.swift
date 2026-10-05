import CoreGraphics
import Foundation
import ImageIO

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: render-app-icon.swift <output.png>")
}

let side = 1024
let outputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
let bitmapInfo = CGBitmapInfo.byteOrder32Big.union(
    CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
)

guard let context = CGContext(
    data: nil,
    width: side,
    height: side,
    bitsPerComponent: 8,
    bytesPerRow: side * 4,
    space: colorSpace,
    bitmapInfo: bitmapInfo.rawValue
) else {
    fatalError("Could not create the app icon bitmap")
}

context.setAllowsAntialiasing(true)
context.setShouldAntialias(true)

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: colorSpace, components: [red, green, blue, alpha])!
}

func gradient(_ colors: [CGColor]) -> CGGradient {
    CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1])!
}

let background = gradient([
    color(0.035, 0.075, 0.18),
    color(0.13, 0.23, 0.43),
])
context.drawLinearGradient(
    background,
    start: CGPoint(x: 0, y: 0),
    end: CGPoint(x: side, y: side),
    options: []
)

let sunCenter = CGPoint(x: 330, y: 685)
context.setStrokeColor(color(1, 0.72, 0.28))
context.setLineWidth(24)
context.setLineCap(.round)
for index in 0..<8 {
    let angle = CGFloat(index) * .pi / 4
    let innerRadius: CGFloat = 177
    let outerRadius: CGFloat = 218
    context.move(to: CGPoint(
        x: sunCenter.x + cos(angle) * innerRadius,
        y: sunCenter.y + sin(angle) * innerRadius
    ))
    context.addLine(to: CGPoint(
        x: sunCenter.x + cos(angle) * outerRadius,
        y: sunCenter.y + sin(angle) * outerRadius
    ))
}
context.strokePath()

let sunGradient = gradient([
    color(1, 0.92, 0.55),
    color(1, 0.63, 0.19),
])
let sunBounds = CGRect(x: sunCenter.x - 151, y: sunCenter.y - 151, width: 302, height: 302)
context.saveGState()
context.addEllipse(in: sunBounds)
context.clip()
context.drawLinearGradient(
    sunGradient,
    start: CGPoint(x: sunBounds.minX, y: sunBounds.maxY),
    end: CGPoint(x: sunBounds.maxX, y: sunBounds.minY),
    options: []
)
context.restoreGState()
context.setStrokeColor(color(1, 0.94, 0.68, 0.9))
context.setLineWidth(4)
context.strokeEllipse(in: CGRect(x: sunCenter.x - 147, y: sunCenter.y - 147, width: 294, height: 294))

let moonCenter = CGPoint(x: 730, y: 340)
let moonPath = CGMutablePath()
moonPath.addEllipse(in: CGRect(x: moonCenter.x - 196, y: moonCenter.y - 196, width: 392, height: 392))
moonPath.addEllipse(in: CGRect(x: moonCenter.x - 125, y: moonCenter.y - 171, width: 320, height: 320))
context.addPath(moonPath)
context.setFillColor(color(0.88, 0.93, 1))
context.drawPath(using: .eoFill)

func drawSpark(at point: CGPoint, radius: CGFloat, in context: CGContext) {
    context.saveGState()
    context.setStrokeColor(color(0.84, 0.91, 1, 0.92))
    context.setLineWidth(max(4, radius * 0.2))
    context.setLineCap(.round)
    context.move(to: CGPoint(x: point.x, y: point.y - radius))
    context.addLine(to: CGPoint(x: point.x, y: point.y + radius))
    context.move(to: CGPoint(x: point.x - radius, y: point.y))
    context.addLine(to: CGPoint(x: point.x + radius, y: point.y))
    context.strokePath()
    context.restoreGState()
}

drawSpark(at: CGPoint(x: 820, y: 780), radius: 22, in: context)
drawSpark(at: CGPoint(x: 570, y: 520), radius: 14, in: context)
context.setFillColor(color(0.89, 0.94, 1, 0.82))
context.fillEllipse(in: CGRect(x: 840, y: 605, width: 12, height: 12))
context.fillEllipse(in: CGRect(x: 540, y: 235, width: 10, height: 10))

guard let image = context.makeImage(),
      let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, "public.png" as CFString, 1, nil) else {
    fatalError("Could not encode the app icon PNG")
}
CGImageDestinationAddImage(destination, image, nil)
guard CGImageDestinationFinalize(destination) else {
    fatalError("Could not write app icon to \(outputURL.path)")
}
