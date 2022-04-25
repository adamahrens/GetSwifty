//
//  FlightDetails.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import SwiftUI

struct FlightDetails: View {
  var body: some View {
    GeometryReader { reader in
      VStack {
        FlightInfo()
          .frame(height: reader.size.height * 0.55)
          .background(Color("Pink"))
        
        BoardingPass()
          .frame(height: reader.size.height * 0.45)
          .background(Color("Blue"))
      }.background(Color("Pink"))
    }
  }
}

struct FlightDetails_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FlightDetails()
        .previewDevice(.iphone8plus)
    
      FlightDetails()
        .previewDevice(.iphone12ProMax)
      
      FlightDetails()
        .previewDevice(.iphone13Mini)
      
      FlightDetails()
        .previewDevice(.iphoneSE)
      
      FlightDetails()
        .previewDevice(.iphone6)
    }
  }
}

struct CirularView: View {
  var body: some View {
    HStack {}
      .frame(width: 20, height: 20)
      .background(Color("Yellow"))
      .clipShape(Circle())
  }
}
