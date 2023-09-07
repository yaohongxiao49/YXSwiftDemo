//
//  ContentView.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //地图
            MapLearn()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            //图片
            ImageLearn()
                .offset(y: -130)
                .padding(.bottom, -130)
            
            //文字
            TextLearn()
            
            Spacer()
        }   
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
