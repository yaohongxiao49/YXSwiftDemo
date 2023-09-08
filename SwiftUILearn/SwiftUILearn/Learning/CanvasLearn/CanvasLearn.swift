//
//  CanvasLearn.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/8.
//
/// 绘图

import SwiftUI

struct CanvasLearn: View {
    
    var canvasLearn3Symbols: some View {
        ForEach(0..<8) { index in
            CanvasLearn3(
                angle: .degrees(Double(index) / Double(8)) * 360.0
            )
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack {
            CanvasLearn1()
            
            GeometryReader { geometry in
                canvasLearn3Symbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
    }
}

struct CanvasLearn_Previews: PreviewProvider {
    static var previews: some View {
        CanvasLearn()
    }
}
