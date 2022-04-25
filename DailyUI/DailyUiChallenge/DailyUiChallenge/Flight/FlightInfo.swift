//
//  FlightInfo.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import SwiftUI

struct FlightInfo: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "airplane")
          .resizable()
          .frame(width: 30, height: 30)
        Text("Alpha")
          .fontWeight(.bold)
          .font(.largeTitle)
      }.frame(height: 30)
      
      HStack {
        Text("Flight 5791 /// Nov. 3, 2018")
          .tracking(3)
          .lineLimit(2)
          .font(.callout)
        Spacer()
        CirularView()
      }
      .padding([.trailing], 1)
      
      FlightDetailItem(detail: "Adam Ahrens", label: "Passenger")
      
      HStack {
        FlightDetailItem(detail: "08:45AM CST", label: "Boarding Time")
        FlightDetailItem(detail: "C-17", label: "Gate")
      }
      
      LazyVGrid(columns: [.init(.flexible()),
                       .init(.fixed(80)),
                       .init(.fixed(80))]) {
        FlightDetailItem(detail: "Comfort+", label: "Class")
        FlightDetailItem(detail: "1", label: "Zone")
        FlightDetailItem(detail: "2A", label: "Seat")
      }.padding(.bottom, 7)
    }
    .padding([.leading, .trailing])
    .foregroundColor(Color("Blue"))
    .background(Color("Pink"))
  }
}

struct FlightInfo_Previews: PreviewProvider {
  static var previews: some View {
      FlightInfo()
  }
}
