//
//  ViewController.swift
//  FaceItV2
//
//  Created by Ali Siddiqui on 8/9/16.
//  Copyright © 2016 Ali Siddiqui. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .open, mouth: .neutral) {
        didSet {
            setFace()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            setFace()
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale(_:))
            ))
            
            let happierFaceGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.happierFace))
            
            happierFaceGestureRecognizer.numberOfTouchesRequired = 1
            happierFaceGestureRecognizer.direction = .down
            
            faceView.addGestureRecognizer(happierFaceGestureRecognizer)
            
            let sadderFaceGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.sadderFace))
            
            sadderFaceGestureRecognizer.numberOfTouchesRequired = 1
            sadderFaceGestureRecognizer.direction = .up
            
            faceView.addGestureRecognizer(sadderFaceGestureRecognizer)
        }
    }
    
    @IBAction func mouthChange(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .open:         expression.eyes = .squinting
            case .squinting:    expression.eyes = .closed
            case .closed:       expression.eyes = .open
            }
        }
    }
    
    fileprivate func setFace() {
        if faceView != nil {
            
            switch expression.eyes {
            case .open:         faceView.eyeState = .open
            case .squinting:    faceView.eyeState = .squinting
            case .closed:       faceView.eyeState = .closed
            }
            
            switch expression.mouth {
            case .sad:      faceView.mouthCurvature = -1
            case .smirk:    faceView.mouthCurvature = -0.5
            case .neutral:  faceView.mouthCurvature = 0
            case .smile:    faceView.mouthCurvature = +0.5
            case .grin:     faceView.mouthCurvature = +1
            }
            
            faceView.setNeedsDisplay()
        }
    }
    
    @objc fileprivate func happierFace() {
        expression.mouth = expression.mouth.happierFace()
    }
    
    @objc fileprivate func sadderFace() {
        expression.mouth = expression.mouth.sadderFace()
    }
}

