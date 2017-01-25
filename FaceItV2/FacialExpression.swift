//
//  FacialExpression.swift
//  FaceItV2
//
//  Created by Ali Siddiqui on 8/10/16.
//  Copyright © 2016 Ali Siddiqui. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    var eyes: Eye
    
    var mouth: Mouth
    
    enum Eye {
        case open
        case squinting
        case closed
    }
    
    enum Mouth: Int {
        case sad
        case smirk
        case neutral
        case smile
        case grin
        
        func sadderFace() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .sad
        }
        
        func happierFace() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .grin
        }
    }
    
    
}
