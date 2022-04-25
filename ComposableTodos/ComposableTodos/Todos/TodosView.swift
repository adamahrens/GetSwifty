//
//  TodosView.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import SwiftUI
import ComposableArchitecture

struct TodosView: View {
  let store: Store<TodosState, TodosActions>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Picker("Filter", selection: viewStore.binding(get: \.filter, send: TodosActions.filter).animation()) {
            ForEach(Filter.allCases, id: \.self) { f in
              Text(f.rawValue).tag(f)
            }
          }
          .pickerStyle(.segmented)
          .padding(.horizontal)
          
          List(viewStore.filteredTodos) { todo in
            HStack {
              Text(todo.description)
                .strikethrough(todo.isComplete)
              Spacer()
              Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
                .onTapGesture {
                  viewStore.send(.delete(todo))
                }
              Image(systemName: "checkmark")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
                .onTapGesture {
                  viewStore.send(.toggle(todo))
                }
            }
          }
        }
        .sheet(isPresented:
                viewStore.binding(get: \.shouldShowAddView,
                                  send: TodosActions.showAddSheet)) {
          AddTodoView(store: store)
        }
        .navigationTitle("Todos")
         .toolbar {
            Button("Add") {
              viewStore.send(.showAddSheet(true))
            }
          }
          .onAppear {
            viewStore.send(.didAppear)
          }
      }
    }
  }
}

struct TodosView_Previews: PreviewProvider {
  static var previews: some View {
    TodosView(store: Store(initialState: TodosState(filter: .all, todos: [Todo(id: UUID(), description: "My first todo", isComplete: false), Todo(id: UUID(), description: "Another Really Long Todo What Happens", isComplete: true)]), reducer: todosReducer, environment: TodosEnvironment(mainQueue: .main)))
  }
}
