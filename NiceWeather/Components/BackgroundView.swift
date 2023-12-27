//
//  BackgroundView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/10.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        ZStack {
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("blueBackground"), Color("lightBackground")],
                                   startPoint: .top,
                                   endPoint: .bottom))
    }
}

#Preview {
    BackgroundView()
}
