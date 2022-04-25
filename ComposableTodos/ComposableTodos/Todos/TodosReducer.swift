//
//  TodosReducer.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import Foundation
import ComposableArchitecture

let todosReducer = Reducer<TodosState, TodosActions, TodosEnvironment> { state, action, environment in
  print("Todos Reducer Called")
  switch action {
  case .didAppear:
    print("Did Appear Action")
    return .none
  case .showAddSheet(let present):
    print("Show Add Sheet Action")
    state.shouldShowAddView = present
    return .none
  case .filter(let filter):
    print("Filter Action")
    state.filter = filter
    return .none
  case .loaded(let todos):
    print("Loaded Actions")
    state.todos = todos
    return .none
  case .toggle(let todo):
    print("Toggle Action")
    let mapped = state.todos.map { t -> Todo in
      if t.id == todo.id {
        return Todo(id: t.id, description: t.description, isComplete: !t.isComplete)
      }
      
      return t
    }
    state.todos = mapped
    return .none
  case .delete(let todo):
    print("Delete Action")
    state.todos = state.todos.filter { $0.id != todo.id }
    return .none
  case .add(let text):
    print("Add Action")
    state.newTodoToAdd = text
    return .none
  case .save:
    print("Save Action")
    let todo = Todo(id: UUID(), description: state.newTodoToAdd, isComplete: false)
    state.todos.append(todo)
    state.newTodoToAdd = ""
    return .none 
  }
}
