//
//  RootView.swift
//  OTUS-iDP-03
//
//  Created by Igor Andryushenko on 14.04.2021.
//

import SwiftUI
import UIComponents


struct RootView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var suffViewModel: SuffViewModel
    @State var customText = ""
    
    var body: some View {
        
        VStack {
            Picker("SuffixList", selection: $selectedIndex, content: {
                Text("All List").tag(0)
                Text("Top10_3x").tag(1)
                Text("Top10_5x").tag(2)
            })
            .onChange(of: selectedIndex) {
                print($0)
                suffViewModel.type = $0
                suffViewModel.loadPage()
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedIndex == 0{
                TextFieldWithDebounce(debouncedText: $customText)
                
                Toggle("ASC/DESC", isOn: $suffViewModel.isASC)
                    .onChange(of: suffViewModel.isASC) { value in
                        suffViewModel.loadPage()
                    }
            }
            
            NavControllerView(transition: .custom(.moveAndFade)) {
                ListScreen()
            }
            
            Spacer.init()
            
        }
    }
}

struct TextFieldWithDebounce : View {
    @Binding var debouncedText : String
    @EnvironmentObject var suffViewModel: SuffViewModel
    
    var body: some View {
    
        VStack {
            TextField("Enter Something", text: $suffViewModel.searchText)
                .frame(height: 30)
                .padding(.leading, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .padding(.horizontal, 20)
        }.onReceive(suffViewModel.$debouncedText) { (val) in
            debouncedText = val
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

extension AnyTransition {
    
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.scale.combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
}
