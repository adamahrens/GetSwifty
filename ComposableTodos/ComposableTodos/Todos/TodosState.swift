//
//  TodosState.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import Foundation

enum Filter: String, Equatable, CaseIterable {
  case all = "All"
  case inProgress = "In Progress"
  case done = "Done"
}

struct TodosState: Equatable {
  var filter = Filter.all
  var todos = [Todo]()
  var shouldShowAddView = false
  var newTodoToAdd = ""
  var filteredTodos: [Todo] {
    switch filter {
      case .all: return todos
      case .done: return todos.filter { $0.isComplete }
      case .inProgress: return todos.filter { !$0.isComplete }
    }
  }
}
