//
//  URLResponse+Extensions.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

extension URLResponse {
  /// Is it an HTTPUrlResponse and status code 200 < 300
  var is200Status: Bool {
    guard let r = self as? HTTPURLResponse else { return false }
    return 200..<300 ~= r.statusCode
  }
}
