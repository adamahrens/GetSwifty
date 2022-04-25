//
//  AddTodoView.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/22/22.
//

import SwiftUI
import ComposableArchitecture

struct AddTodoView: View {
  let store: Store<TodosState, TodosActions>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        Text("Add Todo")
          .font(.largeTitle)
          .fontWeight(.semibold)
          .padding(.leading, 20)
        TextField("Add Todo", text: viewStore.binding(get: \.newTodoToAdd, send: TodosActions.add))
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .disableAutocorrection(true)
          .padding([.leading, .trailing], 20)
        
        HStack {
          Spacer()
          Button {
            viewStore.send(.save)
            viewStore.send(.showAddSheet(false))
          } label: {
            Text("Save")
          }
          .buttonStyle(BorderedButtonStyle())
          Spacer()
        }
      }
    }
  }
}

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView(store: Store(initialState: TodosState(filter: .all, todos: [], shouldShowAddView: true, newTodoToAdd: ""), reducer: todosReducer, environment: TodosEnvironment(mainQueue: .main)))
  }
}
