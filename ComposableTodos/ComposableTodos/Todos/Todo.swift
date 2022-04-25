//
//  Todo.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import Foundation

struct Todo: Equatable, Identifiable, Hashable {
  let id: UUID
  let description: String
  let isComplete: Bool
}
