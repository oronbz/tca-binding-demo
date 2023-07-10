//
//  ContentView.swift
//  TCABindingDemo
//
//  Created by Oron Ben Zvi on 10/07/2023.
//

import SwiftUI
import ComposableArchitecture

struct Feature: Reducer {
    struct State: Equatable {
        @BindingState var isSheetPresented = false
    }
    
    enum Action: Equatable, BindableAction {
        case buttonTapped
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Feature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                state.isSheetPresented = true
                return .none
            case .binding:
                return .none
            }
        }
    }
}

struct ContentView: View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Button("Click me!") {
                    viewStore.send(.buttonTapped)
                }
            }
            .sheet(isPresented: viewStore.binding(\.$isSheetPresented)) {
                Text("Hello from sheet")
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(initialState: .init()) {
            Feature()
        })
    }
}
