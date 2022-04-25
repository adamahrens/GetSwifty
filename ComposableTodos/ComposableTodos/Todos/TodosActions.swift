//
//  TodosActions.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import Foundation

enum TodosActions: Equatable {
  case didAppear
  case loaded([Todo])
  case toggle(Todo)
  case filter(Filter)
  case showAddSheet(Bool)
  case add(String)
  case delete(Todo)
  case save
}
