import UIKit

struct DataUpload: Codable {
  let name: String
  let language: String
  let version: Double
}

let upload = DataUpload(name: "My Uploaded Data", language: "Swift", version: 1.0)

guard let url = URL(string: "http://localhost:8080/upload") else { fatalError("Unable to build localhost URL") }


guard let data = try? JSONEncoder().encode(upload) else {
  fatalError("Unable to encode data")
}
// Time to upload
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
  
  if let e = error {
    fatalError("Error uploading data \(e.localizedDescription)")
  }
  
  if let res = response as? HTTPURLResponse {
    print("Response Status Code \(res.statusCode)")
  }
}.resume()
