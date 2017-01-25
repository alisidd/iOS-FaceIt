//
//  EmotionSelectorViewController.swift
//  FaceItV2
//
//  Created by Ali Siddiqui on 8/11/16.
//  Copyright © 2016 Ali Siddiqui. All rights reserved.
//

import UIKit

class EmotionSelectorViewController: UIViewController {
    
    let emotionModels = ["showHappy": FacialExpression(eyes: .open, mouth: .grin),
                         "showSad": FacialExpression(eyes: .open, mouth: .sad),
                         "showUnimpressed": FacialExpression(eyes: .closed, mouth: .sad),
                         "showSrs": FacialExpression(eyes: .squinting, mouth: .neutral)]
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationvc = segue.destination as? UINavigationController {
            if let destinationvc = navigationvc.visibleViewController as? FaceViewController {
                if let identifier = segue.identifier {
                    destinationvc.expression = emotionModels[identifier]!
                    if let sendingButton = sender as? UIButton {
                        destinationvc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
    
}
