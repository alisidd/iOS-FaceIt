//
//  FaceView.swift
//  FaceItV2
//
//  Created by Ali Siddiqui on 8/9/16.
//  Copyright © 2016 Ali Siddiqui. All rights reserved.
//

import UIKit

@IBDesignable class FaceView: UIView {
    
    @IBInspectable var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var mouthCurvature: CGFloat = 0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    @IBInspectable var lineWidth: CGFloat = 5 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var eyeState: EyeState = .open { didSet { setNeedsDisplay() } }
    
    func changeScale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default: break
        }
    }
    
    enum EyeState {
        case open
        case squinting
        case closed
    }
    
    var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    struct Ratios {
        static let RatioOfEyeRadius: CGFloat = 3
        static let RatioOfEyeCenter: CGFloat = 3
        
        static let RatioOfEyeCenterToSkullX: CGFloat = 3
        static let RatioOfEyeCenterToSkullY: CGFloat = 6
        static let eyeOffset = 10
        
        static let RatioOfSkullCenterToMouthX: CGFloat = 2.5
        static let RatioOfSkullCenterToMouthY: CGFloat = 2.5
        static let RatioOfSkullRadiusToMouthWidth: CGFloat = 0.9
        static let RatioOfSkullRadiusToMouthHeight: CGFloat = 3
        
    }
    
    enum Eye {
        case left, right
    }
    
    override func draw(_ rect: CGRect) {
        color.setStroke()
        pathForCircleCenteredAt(skullCenter, withRadius: skullRadius).stroke()
        
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        
        pathForMouth().stroke()
    }
    
    func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        let eyeRadius = skullRadius / Ratios.RatioOfEyeRadius
        
        let eyeCenterY: CGFloat = skullCenter.y - skullRadius / Ratios.RatioOfEyeCenterToSkullY
        
        let eyeCenterX: CGFloat
        
        switch eye {
        case .left:
            eyeCenterX = skullCenter.x - skullRadius / Ratios.RatioOfEyeCenterToSkullX - 3
        case .right:
            eyeCenterX = skullCenter.x + skullRadius / Ratios.RatioOfEyeCenterToSkullX + 3
        }
        
        switch eyeState {
        case .open:
            return pathForCircleCenteredAt(CGPoint(x: eyeCenterX, y: eyeCenterY), withRadius: eyeRadius)
        case .squinting:
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            
            let start = CGPoint(x: CGFloat(Double(eyeCenterX) - Double(eyeRadius)), y: eyeCenterY)
            let end = CGPoint(x: CGFloat(Double(eyeCenterX) + Double(eyeRadius)), y: eyeCenterY)
            
            let width = end.x - start.x
            
            var cp1 = CGPoint(x: width * 0.3 + start.x, y: start.y + 30)
            var cp2 = CGPoint(x: width * 0.7 + start.x, y: start.y + 30)
            
            path.move(to: start)
            path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
            
            cp1 = CGPoint(x: width * 0.3 + start.x, y: start.y - 30)
            cp2 = CGPoint(x: width * 0.7 + start.x, y: start.y - 30)
            
            path.move(to: start)
            path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
            
            return path
        case .closed:
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            
            path.move(to: CGPoint(x: CGFloat(Double(eyeCenterX) - Double(eyeRadius)), y: eyeCenterY))
            
            path.addLine(to: CGPoint(x: CGFloat(Double(eyeCenterX) + Double(eyeRadius)), y: eyeCenterY))
            
            return path
        }
    }
    
    func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.RatioOfSkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.RatioOfSkullRadiusToMouthHeight
        let mouthX = skullCenter.x - mouthWidth / 2
        let mouthY = skullCenter.y + skullRadius / Ratios.RatioOfSkullCenterToMouthY
        
        
        let mouthRect = CGRect(x: mouthX, y: mouthY, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = mouthCurvature * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        return path
    }
    
    func pathForCircleCenteredAt(_ center: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        
        path.lineWidth = lineWidth
        
        return path
    }
}
