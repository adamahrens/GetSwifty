import Foundation

let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
print(documentsURL?.absoluteString ?? "No valid")

extension FileManager {
  /// URL for User's document directory
  static var documentsURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}

print(FileManager.documentsURL)
print(FileManager.documentsURL.path)

let url = URL(fileURLWithPath: "Tasks", relativeTo: FileManager.documentsURL).appendingPathExtension("json")
print(url.lastPathComponent)
