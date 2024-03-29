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

struct AnimalsNearYouView: View {
  @ObservedObject var viewModel: AnimalsNearYouViewModel
  
//  @State var animals = [AnimalEntity]()
  
  @FetchRequest(sortDescriptors: AnimalEntity.defaultSorts, animation: .default)
  var animals: FetchedResults<AnimalEntity>
  
  // New with iOS 15
//  @SectionedFetchRequest<String, AnimalEntity>(
//    sectionIdentifier: \AnimalEntity.animalSpecies,
//    sortDescriptors: [
//      NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true),
//      NSSortDescriptor(keyPath: \AnimalEntity.species, ascending: true)
//
//      ],
//    animation: .default
//  ) private var sectionedAnimals:
//      SectionedFetchResults<String, AnimalEntity>

//  @State var isLoading = true
//  private let requestManager = RequestManager()

  var body: some View {
    NavigationView {
      AnimalListView(animals: animals) {
        if !animals.isEmpty && viewModel.hasMoreAnimals {
//          ProgressView("Finding more animals...")
//            .padding()
//            .frame(maxWidth: .infinity)
            HStack(alignment: .center) {
              LoadingAnimation()
                .frame(maxWidth: 125, minHeight: 125)
              Text("Loading more animals...")
            }
            .task {
              await viewModel.fetchMoreAnimals()
            }
        }
      }
      .task {
        await viewModel.fetchAnimals()
      }
      .listStyle(.plain)
      .navigationTitle("Animals near you")
      .overlay {
        if viewModel.isLoading && animals.isEmpty {
          ProgressView("Finding Animals near you...")
        }
      }
    }.navigationViewStyle(StackNavigationViewStyle())
  }

  /*
  func fetchAnimals() async {
    do {
      let animalsContainer: AnimalsContainer = try await requestManager.perform(AnimalsRequest.getAnimalsWith(
        page: 1,
        latitude: nil,
        longitude: nil))
//      let animals = animalsContainer.animals
//      self.animals = animals
      for var animal in animalsContainer.animals {
        animal.toManagedObject()
      }
      await stopLoading()
    } catch {
      print("Error fetching animals...\(error)")
    }
  }

  @MainActor
  func stopLoading() async {
    isLoading = false
  }
   */
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalsNearYouView(viewModel:
                        AnimalsNearYouViewModel(
                          animalFetcher: AnimalsFetcherMock(),
                          animalStore: AnimalStoreService(context: CoreDataHelper.previewContext)
                        ))
      .environment(\.managedObjectContext,
           PersistenceController.preview.container.viewContext)
      .preferredColorScheme(.dark)
  }
}
