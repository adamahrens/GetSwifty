//
//  BoardingPass.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import SwiftUI

struct BoardingPass: View {
  private let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
  
  var body: some View {
    HStack {
      LazyVGrid(columns: columns) {
        VStack(alignment: .leading) {
          LazyVGrid(columns: [.init(.fixed(60)), .init(.flexible())]) {
            Image(systemName: "airplane.departure")
              .resizable()
              .modifier(Square(by: 20))
            
            VStack(alignment: .center) {
              Text("SEA")
                .font(.largeTitle)
                .fontWeight(.bold)
              Text("Seatac, WA")
                .font(.footnote)
                .fontWeight(.thin)
            }
            
            Image(systemName: "airplane.arrival")
              .resizable()
              .modifier(Square(by: 20))
            
            VStack(alignment: .center) {
              Text("LAX")
                .font(.largeTitle)
                .fontWeight(.bold)
              Text("Los Angeles, CA")
                .fontWeight(.thin)
                .font(.system(size: 10))
                .frame(minWidth: 140)
            }.padding(.bottom, 16)
          }
        }
      
        QRCode()
      }
    }
    .padding([.top, .bottom], 20)
    .foregroundColor(Color("Pink"))
    .background(Color("Blue"))
  }
}

struct BoardingPass_Previews: PreviewProvider {
  static var previews: some View {
    BoardingPass()
  }
}
