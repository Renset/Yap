//
//  BackgroundView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct BackgroundView: View {
    var red: Double
    var green: Double
    var blue: Double
    
    var body: some View {
        Color(red: red, green: green, blue: blue)
            .edgesIgnoringSafeArea(.all)
    }
}


struct BackgroundView_Preview: PreviewProvider {
    static var previews: some View {
        BackgroundView(red: 15 / 255, green: 70 / 255, blue: 50 / 255)
    }
}
