//
//  AnimalsRequest.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

enum AnimalsRequest: RequestProtocol {
  case getAnimalsWith(page: Int, latitude: Double?, longitude: Double?)
  case getAnimalsBy(name: String, age: String?, type: String?)
  
  var path: String {
    "/v2/animals"
  }
  
  var requestType: RequestType {
    .GET
  }
  
  var queryParams: [String : String] {
    switch self {
    case let .getAnimalsBy(name, age, type):
      var params = [String:String]()
      if !name.isEmpty {
        params["name"] = name
      }
      
      if let a = age {
        params["age"] = a
      }
      
      if let t = type {
        params["type"] = t
      }
      
      return params
    case let .getAnimalsWith(page, latitude, longitude):
      var params = ["page" : "\(page)"]
      
      if let lat = latitude {
        params["latitude"] = "\(lat)"
      }
      
      if let long = longitude {
        params["longitude"] = "\(long)"
      }
      
      return params
    }
  }
}
