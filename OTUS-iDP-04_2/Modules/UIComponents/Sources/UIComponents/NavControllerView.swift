//
//  NavControllerView.swift
//  SwiftUIAppNav
//
//  Created by exey on 14.12.2020.
//

import SwiftUI

// Model

private struct ScreenStack {
    
    private var screens = [Screen]()
    
    func top() -> Screen? {
        screens.last
    }
    
    mutating func push(_ s: Screen) {
        screens.append(s)
    }
    
    mutating func popToPrevious() {
        _ = screens.popLast()
    }
    
    mutating func popToRoot() {
        screens.removeAll()
    }
    
}

private struct Screen: Identifiable, Equatable {
    
    let id: String
    let nextScreen: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}

enum NavType {
    case push
    case pop
}

public enum PopDestination {
    case previous
    case root
}

// MARK: - More UI Logic

public enum NavTransition {
    case none
    case custom(AnyTransition)
}

class NavControllerViewModel: ObservableObject {
    
    @Published fileprivate var currentScreen: Screen?
    private var screenStack = ScreenStack() {
        didSet {
            currentScreen = screenStack.top()
        }
    }
    
    // for transition
    var navigationType: NavType = .push
    private let easing: Animation
    
    init(easing: Animation) {
        self.easing = easing
    }
    
    func push<S: View>(_ screenView: S) {
        withAnimation(easing) {
            navigationType = .push
            let screen = Screen(id: UUID().uuidString, nextScreen: AnyView(screenView))
            screenStack.push(screen)
        }
    }
    
    func pop(to: PopDestination = .previous) {
        withAnimation(easing) {
            navigationType = .pop
            switch to {
            case .root:
                screenStack.popToRoot()
            case .previous:
                screenStack.popToPrevious()
            }
        }
    }
}

public struct NavControllerView<Content>: View where Content: View {
    
    @ObservedObject var viewModel: NavControllerViewModel
    
    private let content: Content
    private let transitions: (push: AnyTransition, pop: AnyTransition)
    
    public init(transition: NavTransition,
                easing: Animation = .easeOut(duration: 0.33),
                @ViewBuilder content: @escaping () -> Content) {
        
        viewModel = NavControllerViewModel(easing: easing)
        self.content = content()
        
        switch transition {
            case .custom(let trans):
                transitions = (trans, trans)
            case .none:
                transitions = (.identity, .identity)
            
        }
        
    }
    
    public var body: some View {
        let isRoot = viewModel.currentScreen == nil
        return ZStack {
            if isRoot {
                content
                    .transition(viewModel.navigationType == .push ? transitions.push : transitions.pop)
                    .environmentObject(viewModel)
            } else {
                viewModel.currentScreen!.nextScreen
                    .transition(viewModel.navigationType == .push ? transitions.push : transitions.pop)
                    .environmentObject(viewModel)
            }
        }
    }
}

public struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    
    @EnvironmentObject var viewModel: NavControllerViewModel
    
    private let destination: Destination
    private let label: () -> Label
    
    public init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            push()
        }
    }
    
    private func push() {
        viewModel.push(destination)
    }
    
}

public struct NavPopButton<Label>: View where Label: View {
    
    @EnvironmentObject var viewModel: NavControllerViewModel
    
    private let destination: PopDestination
    private let label: () -> Label
    
    public init(destination: PopDestination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            push()
        }
    }
    
    private func push() {
        viewModel.pop(to: destination)
    }
    
}


/*
struct NavControllerView_Previews: PreviewProvider {
    static var previews: some View {
        NavControllerView()
    }
}*/
