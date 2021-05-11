//
//  RamScreen.swift
//  OTUS-iDP-03
//
//  Created by Igor Andryushenko on 14.04.2021.
//

import SwiftUI
import UIComponents


struct ListScreen: View {
    @EnvironmentObject var suffViewModel: SuffViewModel
    
    
    var body: some View {
        LazyView{
            NavigationView {
                List {
                    Section(header: Text("SuffList")) {
                        if suffViewModel.type == 0{
                            ForEach(suffViewModel.allSuffList) { item in
                                Text("\(item.name) \(item.count)")
                                
                            }
                        } else if suffViewModel.type == 1 {
                            ForEach(suffViewModel.suf3xList) { item in
                                Text("\(item.name) \(item.count)")
                            }
                        }
                        else if suffViewModel.type == 2 {
                            ForEach(suffViewModel.suf5xList) { item in
                                Text("\(item.name) \(item.count)")
                            }
                        }
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .onAppear() {
                    suffViewModel.loadPage()
                }
            }
        }
        
    }
    
}

//struct RaMScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RaMScreen()
//    }
//}
