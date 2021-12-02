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

struct RegisterView: View {
  
  // Used for controlling focus on TextFields
  enum Field: Hashable {
    case name
  }
  
  @FocusState var focusedField: Field?
  
  @FocusState var nameFieldFocused: Bool
  
//  @State var name = ""
  
  @EnvironmentObject var userManager: UserManager
  
  private func registerUser() {
    if userManager.settings.rememberUser {
      userManager.persistProfile()
    } else {
      userManager.clear()
    }
    
    userManager.persistSettings()
    userManager.setRegistered()
    
    nameFieldFocused = false
  }
  
  var body: some View {
    GeometryReader { reader in
      VStack {
        Spacer()
        
        BrandingView()
        
        TextField("Enter name", text: $userManager.profile.name)
//          .focused($focusedField, equals: .name)
          .focused($nameFieldFocused)
          .submitLabel(.done)
          
          .bordered()
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .onSubmit(registerUser)
        
        HStack {
          Spacer()
          
          Text("\(userManager.profile.name.count)")
            .font(.caption)
            .foregroundColor(userManager.isUserNameValid() ? .green : .red)
            .padding(.trailing)
    
        }.padding(.bottom)
        
        HStack {
          Spacer()
     
          Toggle(isOn: $userManager.settings.rememberUser) {
            Text("Remember Me")
              .font(.subheadline)
              .foregroundColor(.gray)
          }.fixedSize()
        }
        
        Button {
          registerUser()
        } label: {
          HStack {
            Image(systemName: "checkmark")
              .resizable()
              .frame(width: 16, height: 16, alignment: .center)
            
            Text("Ok")
              .font(.body)
              .bold()
          }.bordered()
           .clipShape(RoundedRectangle(cornerRadius: 8))
        }.disabled(!userManager.isUserNameValid())

        
//        ModifiedContent(
//          content: TextField("Enter name", text: $name),
//          modifier: BorderedViewModifier()
//        )
        
        //        TextField("Enter name", text: $name)
        //          .padding(
        //            EdgeInsets(
        //              top: 8, leading: 16, bottom: 8, trailing: 16))
        //          .background(Color.white)
        //          .overlay(
        //            RoundedRectangle(cornerRadius: 8)
        //              .stroke(lineWidth: 2)
        //              .foregroundColor(.blue)
        //          )
        //          .shadow( color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
        //
        //          .textFieldStyle(CustomTextStyle())
        
//        TextField("Enter name", text: $userManager.profile.name)
//          .textFieldStyle(CustomTextStyle())
//          .clipShape(RoundedRectangle(cornerRadius: 8))
        
        Spacer()
      }.background(WelcomeBackgroundView())
        .padding([.trailing, .leading], 8.0)
    }
  }
}

extension View {
  func bordered() -> some View {
    ModifiedContent(
      content: self,
      modifier: BorderedViewModifier()
    )
  }
}


struct CustomTextStyle: TextFieldStyle {
  public func _body(
    configuration: TextField<Self._Label>) -> some View {
      return configuration
        .padding(
          EdgeInsets(
            top: 8, leading: 16, bottom: 8, trailing: 16))
        .background(Color.white)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .foregroundColor(.blue)
        )
        .shadow( color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
    }
}

struct RegisterView_Previews: PreviewProvider {
  
  static let manager = UserManager(name: "Adam")
  static var previews: some View {
    RegisterView()
      .environmentObject(manager)
  }
}
