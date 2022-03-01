import UIKit
import Foundation

struct User {
  let name: String
}

struct Policy {
  let user: User
  let amount: Double
}

final class CustomerDepartment: ViewStateDidUpdate {
  private var customers = [User]()
  
  var state: CustomerDepartment.State {
    State(customers: self.customers)
  }
  
  func didReceive(viewState: ViewState) {
    if let add = viewState as? AddPolicy {
      customers.append(add.policy.user)
    }
    
    if let remove = viewState as? RemoveCustomer {
      customers = customers.filter { $0.name != remove.name }
    }
  }
  
  struct State {
    let customers: String
    init(customers: [User]) {
      self.customers = customers.map { $0.name }.joined(separator: ",")
    }
  }
}

final class PolicyDepartment: ViewStateDidUpdate {
  private var policies = [Policy]()
  
  func didReceive(viewState: ViewState) {
    if let add = viewState as? AddPolicy {
      policies.append(add.policy)
    }
  }
}

class AddPolicy: ViewState {
  let policy: Policy
  var id: UUID
  
  init(policy: Policy) {
    self.policy = policy
    self.id = UUID()
  }
}

class RemoveCustomer: ViewState {
  let name: String
  var id: UUID
  
  init(name: String) {
    self.name = name
    self.id = UUID()
  }
}

class Claim: ViewState {
  let user: User
  let amount: Double
  var id: UUID
  
  init(user: User, amount: Double) {
    self.user = user
    self.amount = amount
    self.id = UUID()
  }
}

final class AccountingDepartment: ViewStateDidUpdate {
  private var balance: Double
  
  var state: AccountingDepartment.State {
    State(balance: self.balance)
  }
  
  init(balance: Double) {
    self.balance = balance
  }
  
  func didReceive(viewState: ViewState) {
    if let add = viewState as? AddPolicy {
      balance += add.policy.amount
    }
    
    if let claim = viewState as? Claim {
      balance -= claim.amount
    }
  }
  
  struct State {
    let balance: String
    init(balance: Double) {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      self.balance = formatter.string(from: NSNumber(value: balance)) ?? "--"
    }
  }
}

protocol ViewState: AnyObject {
  var id: UUID { get }
}

protocol ViewStateDidUpdate: AnyObject {
  func didReceive(viewState: ViewState)
}

final class DelegateMulticast {
  private var delegates = [ViewStateDidUpdate]()
  
  func add(delegate: ViewStateDidUpdate) {
    delegates.append(delegate)
  }
  
  func invoke(viewState: ViewState) {
    for delegate in delegates {
      delegate.didReceive(viewState: viewState)
    }
  }
}

let accountingDepartment = AccountingDepartment(balance: 100)
let policyDepartment = PolicyDepartment()
let customerDepartment = CustomerDepartment()
let multicast = DelegateMulticast()

multicast.add(delegate: accountingDepartment)
multicast.add(delegate: policyDepartment)
multicast.add(delegate: customerDepartment)

let user1 = User(name: "Adam Ahrens")
let policy1 = Policy(user: user1, amount: 200)

let user2 = User(name: "Trixie")
let policy2 = Policy(user: user2, amount: 150)

let user3 = User(name: "Vincent Vegas")
let policy3 = Policy(user: user3, amount: 150)

multicast.invoke(viewState: AddPolicy(policy: policy1))
multicast.invoke(viewState: AddPolicy(policy: policy2))
multicast.invoke(viewState: AddPolicy(policy: policy3))

print(accountingDepartment.state.balance)
print(customerDepartment.state.customers)

multicast.invoke(viewState: RemoveCustomer(name: "Trixie"))
print(accountingDepartment.state.balance)
print(customerDepartment.state.customers)

multicast.invoke(viewState: Claim(user: user2, amount: 350))
print(accountingDepartment.state.balance)
print(customerDepartment.state.customers)
