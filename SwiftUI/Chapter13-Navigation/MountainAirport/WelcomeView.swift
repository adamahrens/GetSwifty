/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct WelcomeView: View {
  @StateObject var flightInfo = FlightData()
  @StateObject var lastFlightInfo = FlightNavigationInfo()
  @State private var showNextFlight = false
  

  var body: some View {
    /* Before Navigation
    VStack(alignment: .leading) {
      ZStack(alignment: .topLeading) {
        // Background
        Image("welcome-background")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 375, height: 250)
          .clipped()
        //Title
        VStack {
          Text("Mountain Airport")
            .font(.system(size: 28.0, weight: .bold))
          Text("Flight Status")
        }
        .foregroundColor(.white)
        .padding()
      }
      Spacer()
    }.font(.title)
    */
    
    NavigationView {
      ZStack(alignment: .topLeading) {
        Image("welcome-background")
          .resizable()
          .frame(height: 250)
        
        VStack(alignment: .leading) {
          
          // Invisible link that can be activated programatically
          if let id = lastFlightInfo.lastFlightId, let lastFlight = flightInfo.getFlightById(id) {
            NavigationLink(
              destination: FlightDetails(flight: lastFlight),
              isActive: $showNextFlight
            ) { }
          }
         
          NavigationLink(destination: FlightStatusBoard(flights: flightInfo.getDaysFlights(Date()))) {
//            Text("Flight Status")
            WelcomeButtonView(
              title: "Flight Status",
              subTitle: "Departure and arrival information"
            )
          }
          
          if let id = lastFlightInfo.lastFlightId, let lastFlight = flightInfo.getFlightById(id) {
            
            Button {
              showNextFlight = true
            } label: {
              WelcomeButtonView(title: "Last Flight \(lastFlight.flightName)", subTitle: "First flight to leave")
            }
          }
        
          Spacer()
        }.font(.title)
          .foregroundColor(.white)
          .padding()
      }.navigationTitle("Mountain Airport")
    }.environmentObject(lastFlightInfo)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
