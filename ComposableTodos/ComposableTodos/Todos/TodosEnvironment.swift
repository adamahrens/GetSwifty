//
//  TodosEnvironment.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 4/21/22.
//

import Foundation
import ComposableArchitecture

struct TodosEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
}
