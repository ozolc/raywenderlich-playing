/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class Knob: UIControl {
  
  var minimumValue: Float = 0
  var maximumValue: Float = 1
  private (set) var value: Float = 0
  
  private let renderer = KnobRenderer()
  
  var lineWidth: CGFloat {
    get { return renderer.lineWidth }
    set { renderer.lineWidth = newValue }
  }
  
  var startAngle: CGFloat {
    get { return renderer.startAngle }
    set { renderer.startAngle = newValue }
  }
  
  var endAngle: CGFloat {
    get { return renderer.endAngle }
    set { renderer.endAngle = newValue }
  }
  
  var pointerLength: CGFloat {
    get { return renderer.pointerLength }
    set { renderer.pointerLength = newValue }
  }
  
  func setValue(_ newValue: Float, animated: Bool = false) {
    value = min(maximumValue, max(minimumValue, newValue))
    
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
    renderer.setPointerAngle(angleValue, animated: animated)
  }
  
  var isContinious = true

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    renderer.updateBounds(bounds)
    renderer.color = tintColor
    renderer.setPointerAngle(renderer.startAngle, animated: false)
    
    layer.addSublayer(renderer.trackLayer)
    layer.addSublayer(renderer.pointerLayer)
  }

}

private class KnobRenderer {
  private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
  
  let trackLayer = CAShapeLayer()
  let pointerLayer = CAShapeLayer()
  
  
  var color: UIColor = .blue {
    didSet {
      trackLayer.strokeColor = color.cgColor
      pointerLayer.strokeColor = color.cgColor
    }
  }
  
  var lineWidth: CGFloat = 2 {
    didSet {
      trackLayer.lineWidth = lineWidth
      pointerLayer.lineWidth = lineWidth
      updateTrackLayerPath()
      updatePointerLayerPath()
    }
  }
  
  var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }
  
  var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }
  
  var pointerLength: CGFloat = 6 {
    didSet {
      updateTrackLayerPath()
      updatePointerLayerPath()
    }
  }
  
  init() {
    trackLayer.fillColor = UIColor.clear.cgColor
    pointerLayer.fillColor = UIColor.clear.cgColor
  }
  
  func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
    
    if animated {
      let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2
        + min(newPointerAngle, pointerAngle)
      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      animation.values = [pointerAngle, midAngleValue, newPointerAngle]
      animation.keyTimes = [0.0, 0.5, 1.0]
      animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
      pointerLayer.add(animation, forKey: nil)
    }

    
    CATransaction.commit()
    
    pointerAngle = newPointerAngle
  }
  
  private func updateTrackLayerPath() {
    let bounds = trackLayer.bounds
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, lineWidth / 2)
    let radius = min(bounds.width, bounds.height) / 2 - offset
    
    let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    trackLayer.path = ring.cgPath
  }
  
  private func updatePointerLayerPath() {
    let bounds = trackLayer.bounds
    let pointer = UIBezierPath()
    pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
    pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
    pointerLayer.path = pointer.cgPath
  }
  
  func updateBounds( _ bounds: CGRect) {
    trackLayer.bounds = bounds
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    updateTrackLayerPath()
    
    pointerLayer.bounds = trackLayer.bounds
    pointerLayer.position = trackLayer.position
    updatePointerLayerPath()
  }
  
}
