//
//  ComposableTodosApp.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableTodosApp: App {
  var body: some Scene {
      WindowGroup {
        TodosView(store:
                    Store(initialState: TodosState(),
                          reducer: todosReducer,
                          environment: TodosEnvironment(mainQueue: .main))
                  )
      }
  }
}
