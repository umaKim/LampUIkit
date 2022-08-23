//
//  ZoomLevelDistance.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/11.
//

import Foundation

enum ZoomLevelDistance {
    case minusOne, zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven

    typealias Level = Int
    typealias Radius = Int
    
    func getLevel() -> (Level, Radius) {
        switch self {
        case .minusOne:
            return (-1, 400)
            
        case .zero:
            return (0, 600)
            
        case .one:
            return (1, 800)
            
        case .two:
            return (2, 1600)
            
        case .three:
            return (3, 2400)
            
        case .four:
            return (4, 3200)
            
        case .five:
            return (5, 4000)
            
        case .six:
            return (6, 4800)
            
        case .seven:
            return (7, 5600)
            
        case .eight:
            return (8, 6400)
            
        case .nine:
            return (9, 7200)
            
        case .ten:
            return (10, 8000)
            
        case .eleven:
            return (11, 8400)
        }
    }
    
    func selfLevelToRadius(with level: Level) -> Self {
        switch level {
        case -1:
            return .minusOne
            
        case 0:
            return .zero
            
        case 1:
            return .one
            
        case 2:
            return .two
            
        case 3:
            return .three
            
        case 4:
            return .four
            
        case 5:
            return .five
            
        case 6:
            return .six
        
        case 7:
            return .seven
            
        case 8:
            return .eight
            
        case 9:
            return .nine
            
        case 10:
            return .ten
            
        case 11:
            return .eleven
            
        default:
            return .one
        }
    }
}
