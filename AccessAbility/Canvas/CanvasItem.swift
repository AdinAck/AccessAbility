//
//  CanvasItem.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/18/23.
//

import Foundation
import SwiftUI

enum ShapeType {
    case ellipse,
         rectangle,
         line
}

struct CanvasShape: Identifiable, Hashable {
    var id: String
    var type: ShapeType
    var boundingBox: CGRect
    var color: Color = .white
    var thickness: CGFloat = 8
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CanvasItem: Shape {
    let type: ShapeType
    var boundingBox: CGRect
    
    var animatableData: CGRect.AnimatableData {
        get {
            AnimatablePair(AnimatablePair(boundingBox.origin.x, boundingBox.origin.y), AnimatablePair(boundingBox.size.width, boundingBox.size.height))
        }
        
        set {
            (boundingBox.origin.x, boundingBox.origin.y, boundingBox.size.width, boundingBox.size.height) = (newValue.first.first, newValue.first.second, newValue.second.first, newValue.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            switch type {
            case .ellipse:
                path.addEllipse(in: boundingBox)
            case .rectangle:
                path.addRect(boundingBox)
            case .line:
                path.move(to: boundingBox.origin)
                path.addLine(to: boundingBox.origin + boundingBox.size)
            }
        }
    }
}
