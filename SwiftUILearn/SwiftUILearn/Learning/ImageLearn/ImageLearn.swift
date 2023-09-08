//
//  ImageLearn.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/7.
//
///  图片

import SwiftUI

struct ImageLearn: View {
    var body: some View {
        Image("ImageLearn1")
            .clipShape(Circle()) //圆角
            .overlay { //边框
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7) //阴影
    }
}

struct ImageLearn_Previews: PreviewProvider {
    static var previews: some View {
        ImageLearn()
    }
}
