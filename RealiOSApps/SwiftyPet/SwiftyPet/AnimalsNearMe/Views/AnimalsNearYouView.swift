//
//  AnimalsNearYouView.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import SwiftUI

struct AnimalsNearYouView: View {
  private let manager = RequestManager()
  
  func fetchAnimals() async {
    do {
      let container: APIAnimalsContainer = try await manager.send(request: AnimalsRequest.getAnimalsWith(page: 1, latitude: nil, longitude: nil))
      
      self.animals = container.animals
      await stopLoading()
    } catch {
      print("Got error \(error)")
    }
  }
  
  @MainActor
  func stopLoading() async {
    isLoading = false
  }
  
  @State var animals = [Animal]()
  @State var isLoading = true
  
  var body: some View {
    NavigationView {
      List(animals) { animal in
        AnimalRow(animal: animal)
      }
      .task {
        await fetchAnimals()
      }
      .listStyle(.plain)
      .navigationTitle("Animals near you")
      .overlay {
        if isLoading {
          ProgressView("Finding animals...")
        }
      }
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
      AnimalsNearYouView()
  }
}
