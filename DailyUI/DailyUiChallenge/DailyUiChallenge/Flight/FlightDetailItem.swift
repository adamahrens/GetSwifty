//
//  FlightDetailItem.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import SwiftUI

struct FlightDetailItem: View {
  let detail: String
  let label: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(detail)
        .font(.body)
        .bold()
      
      Divider()
        .background(Color("Red"))
      
      Text(label)
        .font(.callout)
        .fontWeight(.light)
        .foregroundColor(Color("Red"))
        .textCase(.uppercase)
        .opacity(0.6)
    }
  }
}

struct FlightDetailItem_Previews: PreviewProvider {
    static var previews: some View {
        FlightDetailItem(detail: "Adam Ahrens", label: "Passenger")
        .foregroundColor(Color("Blue"))
        .background(Color("Pink"))
    }
}
