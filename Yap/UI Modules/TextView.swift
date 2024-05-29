//
//  TextView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct TextView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack {
            if vm.pomodoros.count > 0 {
                Text(vm.pomodoros.joined(separator: " "))
            }

            if vm.isRunning {
                if !vm.isBreak {
                    Text("🍅").opacity(0.6)
                }
                else {
                    Text("☕️").opacity(0.6)
                }
            } else {
                Text(" ")
            }

        }.padding(.top, 1).font(.system(size: 36))
    }
}

struct TextView_Preview: PreviewProvider {
    private static var vm = HomeViewModel()
    static var previews: some View {
        TextView()
            .environmentObject(vm)
    }
}
