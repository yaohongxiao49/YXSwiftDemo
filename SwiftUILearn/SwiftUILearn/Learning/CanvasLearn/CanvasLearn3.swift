//
//  CanvasLearn3.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/8.
//

import SwiftUI

struct CanvasLearn3: View {
    let angle: Angle
    
    var body: some View {
        CanvasLearn2()
            .padding()
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct CanvasLearn3_Previews: PreviewProvider {
    static var previews: some View {
        CanvasLearn3(angle: Angle(degrees: 5))
    }
}
