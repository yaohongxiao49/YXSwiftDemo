//
//  CanvasLearn.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/8.
//
/// 绘图

import SwiftUI

struct CanvasLearn: View {
    
    let angle: Angle
    
//    var CanvasLearn2Symbols: some View {
//        ForEach(0..<8) { index in
//            CanvasLearn2(
//                angle: .degrees(Double(index) / Double(8)) * 360.0
//            )
//        }
//        .opacity(0.5)
//    }
    
    var body: some View {
        ZStack {
            CanvasLearn1()
            
            GeometryReader { geometry in
                CanvasLearn2
                    .padding()
                    .opacity(0.5)
                    .rotationEffect(angle, anchor: .bottom)
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
    }
}

struct CanvasLearn_Previews: PreviewProvider {
    static var previews: some View {
        CanvasLearn(angle: Angle(degrees: 5))
    }
}
