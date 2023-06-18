//
//  Canvas.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import Foundation
import SwiftUI
import Combine

enum ShapeType {
    case ellipse,
         rectangle
}

struct CanvasShape: Identifiable, Hashable {
    var id: String
    var type: ShapeType
    var boundingBox: CGRect
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct World {
    let origin: CGPoint
    let scale: CGFloat
}

class Canvas: ObservableObject {
    // params
    @Published var items: [CanvasShape] = []
    
    // public
    @Published var scale: CGFloat = 1
    @Published var origin: CGPoint = CGPoint.zero
    
    @Published var selected: Set<CanvasShape> = Set()
    @Published fileprivate var tmpSelected: Set<CanvasShape> = Set()
    @Published var selectionRect: CGRect = CGRect.zero
    
    // internal
    @Published fileprivate var mouse: CGPoint = CGPoint.zero
    @Published fileprivate var frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
    
    fileprivate let gridSize: CGFloat = 20
    
    func view() -> some View {
        CanvasView()
            .environmentObject(self)
    }
    
    func center() {
        withAnimation(.spring(response: 1, dampingFraction: 1)) {
            origin = CGPoint.zero
            scale = 1
        }
    }
    
    fileprivate func magnify(delta: CGFloat) {
        let lower: CGFloat = 1 / 125
        let upper: CGFloat = 5
        
        if (lower...upper).contains(scale * (1 + delta)) {
            origin.x -= (mouse.x - origin.x) * delta
            origin.y -= (mouse.y - origin.y) * delta
            scale *= 1 + delta
            
            clampPos()
        }
    }
    
    fileprivate func clampPos() {
        let lower: CGFloat = -625 * gridSize * scale
        let upper: CGFloat = 625 * gridSize * scale
        
        origin.x = min(max(origin.x, lower), upper)
        origin.y = min(max(origin.y, lower), upper)
    }
}

struct CanvasView: View {
    @EnvironmentObject var model: Canvas
    
    func isSelected(_ item: CanvasShape) -> Bool {
        return model.selected.contains(item) || model.tmpSelected.contains(item)
    }
    
    func pathFrom(shape aShape: CanvasShape, origin: CGPoint) -> Path {
        switch aShape.type {
        case .ellipse:
            return Path { path in
                path.addEllipse(in: aShape.boundingBox + origin)
            }
        case .rectangle:
            return Path { path in
                path.addRect(aShape.boundingBox + origin)
            }
        }
    }
    
    @State var tmp: CGPoint = .zero
    
    var body: some View {
        VStack {
            // canvas
            GeometryReader { geometry in
                let frame = geometry.frame(in: CoordinateSpace.global) // for mouse
                
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let origin = model.origin + tmp + center
                
                let world = World(origin: origin, scale: model.gridSize * model.scale)
                
                // background
                Color.black
                Color.white.opacity(0.1)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                tmp.x = gesture.translation.width
                                tmp.y = gesture.translation.height
                            }).onEnded({ gesture in
                                model.origin = model.origin + tmp
                                tmp = .zero
                            }))
                
                // grid
                Grid(width: width, height: height, origin: origin, scale: model.scale, gridSize: model.gridSize, dotSize: 2)
                
                // components
                ForEach(model.items) { item in
                    
                    pathFrom(shape: item, origin: origin)
                        .stroke(style: StrokeStyle(lineWidth: 8, lineJoin: .round))
                        .foregroundColor(.white)
                }
                .animation(.default, value: model.items)
                .drawingGroup()
            }
        }
        .background(.background)
    }
}
