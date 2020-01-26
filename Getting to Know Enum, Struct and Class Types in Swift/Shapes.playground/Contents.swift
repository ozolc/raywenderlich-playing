import Foundation

//for color in ColorName.allCases {
//    print("I love the color \(color).")
//}

enum CSSColor {
    case named(name: ColorName)
    case rgb(red: UInt8, green: UInt8, blue: UInt8)
}

extension CSSColor {
    enum ColorName: String, CaseIterable {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green,
        lime, olive, yellow, navy, blue, teal, aqua
    }
}

extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let red, let green, let blue):
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}

let color1 = CSSColor.named(name: .red)
let color2 = CSSColor.rgb(red: 0xAA, green: 0xAA, blue: 0xAA)

// prints color1 = red, color2 = #AAAAAA
//print("color1 = \(color1), color2 = \(color2)")

extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(red: gray, green: gray, blue: gray)
    }
}

let color3 = CSSColor(gray: 0xaa)
//print(color3) // prints #AAAAAA

protocol Drawable {
    func draw(with context: DrawingContext)
}

protocol DrawingContext {
    func draw(_ circle: Circle)
    func draw(_ rectangle: Rectangle)
}

@dynamicMemberLookup
struct Circle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .red)
    var fillColor = CSSColor.named(name: .yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    // Adopting the Drawable protocol.
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
    
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Mr Circle"]
        return properties[member, default: ""]
    }
}

//let circle = Circle()
//let circleName = circle.name

struct Rectangle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .teal)
    var fillColor = CSSColor.named(name: .aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

final class SVGContext: DrawingContext {
    private var commands: [String] = []
    
    var width = 250
    var height = 250
    
    // 1
    func draw(_ circle: Circle) {
        let command = """
        <circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' \
        stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' \
        stroke-width='\(circle.strokeWidth)' />
        """
        commands.append(command)
    }
    
    // 2
    func draw(_ rectangle: Rectangle) {
        let command = """
        <rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' \
        width='\(rectangle.size.width)' height='\(rectangle.size.height)' \
        stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' \
        stroke-width='\(rectangle.strokeWidth)' />
        """
        commands.append(command)
    }
    
    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        for command in commands {
            output += command
        }
        output += "</svg>"
        return output
    }
    
    var htmlString: String {
        return "<!DOCTYPE html><html><body>" + svgString + "</body></html>"
    }
}

struct SVGDocument {
    var drawables: [Drawable] = []
    
    var htmlString: String {
        let context = SVGContext()
        for drawable in drawables {
            drawable.draw(with: context)
        }
        return context.htmlString
    }
    
    mutating func append(_ drawable: Drawable) {
        drawables.append(drawable)
    }
}

var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)

import WebKit
import PlaygroundSupport
let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view

extension Circle {
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }
    
    // Example of getter-only computed properties
    var area: Double {
        return radius * radius * Double.pi
    }
    var perimeter: Double {
        return 2 * radius * Double.pi
    }
    
    mutating func shift(x: Double, y: Double) {
      center.x += x
      center.y += y
    }
}

extension Rectangle {
    var area: Double {
        return size.width * size.height
    }
    var perimeter: Double {
        return 2 * (size.width + size.height)
    }
}

protocol ClosedShape {
    var area: Double { get }
    var perimeter: Double { get }
}

extension Circle: ClosedShape {}
extension Rectangle: ClosedShape {}

func totalPerimeter(shapes: [ClosedShape]) -> Double {
    return shapes.reduce(0) { $0 + $1.perimeter }
}

totalPerimeter(shapes: [circle, rectangle])
