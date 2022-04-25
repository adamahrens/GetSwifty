//
//  AnimalRow.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import SwiftUI

struct AnimalRow: View {
  let animal: Animal

  var body: some View {
    HStack {
      AsyncImage(url: animal.picture) { image in
        image
          .resizable()
      } placeholder: {
        Image(systemName: "timer")
          .resizable()
          .overlay {
            if animal.picture != nil {
              ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.4))
            }
          }
      }
      .aspectRatio(contentMode: .fit)
      .frame(width: 112, height: 112)
      .cornerRadius(8)

      VStack(alignment: .leading) {
        Text(animal.name)
          .multilineTextAlignment(.center)
          .font(.title3)
      }
      .lineLimit(1)
    }
  }
}

struct AnimalRow_Previews: PreviewProvider {
  static var previews: some View {
    AnimalRow(animal: Animal.mocks.first!)
  }
}
