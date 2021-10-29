/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Combine
import Foundation

@dynamicMemberLookup
final class CheckoutViewModel: ObservableObject {
  private let info: CheckoutInfo
  
  // Input/Bindings
  @Published var selectedShippingOption = ShippingOption(
    name: "",
    duration: "",
    price: 0
  )
  
  @Published var currency = Currency.usd

  // Outputs
  @Published var shippingPrices = [ShippingOption: String]()
  @Published var basePrice = ""
  @Published var additionsPrice = ""
  @Published var totalPrice = ""
  @Published var shippingPrice = ""
  @Published var isUpdatingCurrency = false
  
  var checkoutButton: String {
    self.isAvailable ? "Order now" : "Model unavailable"
  }
  
  init(info: CheckoutInfo) {
    self.info = info
    self.selectedShippingOption = self.shippingOptions[0]
    self.shippingPrices = self.shippingOptions
      .reduce(into: [ShippingOption: String]()) { options, option in
        options[option] = option.price == 0
          ? "Free"
          : option.price.formatted
      }
  }
  
  subscript<T>(dynamicMember keyPath: KeyPath<CheckoutInfo, T>) -> T {
    info[keyPath: keyPath]
  }
}
