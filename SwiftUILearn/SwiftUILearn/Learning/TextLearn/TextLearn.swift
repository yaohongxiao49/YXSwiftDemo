//
//  TextLearn.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/7.
//
//  文字

import SwiftUI

struct TextLearn: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                
                HStack {
                    Text("left")
                    Spacer()
                    Text("right")
                }
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("About Turtle Rock")
                Text("Descriptive text goes here.")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct TextLearn_Previews: PreviewProvider {
    static var previews: some View {
        TextLearn()
    }
}
