// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

import UIKit
import PlaygroundSupport

// Instead of a Shape class use a Circle that conforms
// the Drawable and geometry protocol.

protocol Drawable {
  func draw(on context: CGContext)
}

protocol Geometry {
  var size: CGSize { get }
  func area() -> CGFloat
}

extension Geometry {
  func area() -> CGFloat { return size.width * size.height }
}

//// Challenge

struct Circle: Drawable, Geometry {
  let center: CGPoint
  let radius: CGFloat
  let color: UIColor
  let fillColor: UIColor
  let lineWidth: CGFloat
  
  func draw(on context: CGContext) {
    context.setFillColor(fillColor.cgColor)
    let rect = CGRect(x: center.x-radius, y: center.y-radius, width: diameter, height: diameter)
    context.addEllipse(in: rect)
    context.fillPath()
    context.setStrokeColor(color.cgColor)
    context.addEllipse(in: rect)
    context.setLineWidth(lineWidth)
    context.strokePath()
  }
  
  func area() -> CGFloat {
    .pi * radius * radius
  }
  
  var size: CGSize {
    CGSize(width: diameter, height: diameter)
  }
  
  var diameter: CGFloat {
    radius * 2
  }
}

////////////////////////////////////////////////////////////////////////////////

final class RenderView: UIView {
  
  var shapes: [Drawable] = [] {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
    context.fill(rect)
    
    for shape in shapes {
      shape.draw(on: context)
    }
  }
}

extension UIColor {
  static func rgb(_ r: UInt8, _ g: UInt8, _ b: UInt8) -> UIColor {
    return UIColor(displayP3Red: CGFloat(r)/255,
                   green: CGFloat(g)/255,
                   blue: CGFloat(b)/255, alpha: 1)
    
  }
}

let renderView = RenderView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
renderView.backgroundColor = .lightGray

var shapes: [Drawable] = []

for _ in 1 ... 5 {
  
  let center = CGPoint(x: CGFloat.random(in: 0...renderView.frame.size.width),
                         y: CGFloat.random(in: 0...renderView.frame.size.width))
  let size = CGSize(width: CGFloat.random(in: 50...80),
                    height: CGFloat.random(in: 50...80))
  let lineWidth = CGFloat.random(in: 5...15)
  
  
  
  let colors: [UIColor] = [.rgb(255,0,156),
                           .rgb(255,0,113),
                           .rgb(255,0,219),
                           .rgb(255,0,182),
                           .rgb(255,0,94)]
  // Add a circle here...
  let circle = Circle(center: center, radius: min(size.width, size.height), color: colors.randomElement()!, fillColor: colors.randomElement()!, lineWidth: lineWidth)
  
  shapes.append(circle)
}

renderView.shapes = shapes
PlaygroundPage.current.liveView = renderView
