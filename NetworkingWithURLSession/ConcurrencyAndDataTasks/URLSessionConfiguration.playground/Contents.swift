import UIKit

let session = URLSession.shared
let config = session.configuration
config.allowsCellularAccess
config.allowsExpensiveNetworkAccess
config.httpAdditionalHeaders
config.identifier
config.urlCache?.currentDiskUsage

// Creating a Custom Configuration
let customConfiguration = URLSessionConfiguration.default
customConfiguration.allowsCellularAccess = false
customConfiguration.allowsExpensiveNetworkAccess = false
customConfiguration.httpAdditionalHeaders = ["Content-Type" : "application/json"]

// Options are saved for this
customConfiguration.allowsCellularAccess
customConfiguration.allowsExpensiveNetworkAccess
customConfiguration.httpAdditionalHeaders

// Pass it to your URLSession to use the configuration
let customSession = URLSession(configuration: customConfiguration)

// Could also init with default config and then update it
let anotherCustomSession = URLSession(configuration: .default)
anotherCustomSession.configuration.allowsCellularAccess


// Fetching data
let defaultSession = URLSession(configuration: .default)

guard
  let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=sic")
else { fatalError("Unable to construct URL for searching") }

struct ArtistMatches: Codable {
  let artistId: UInt
  let artistName: String
  let trackId: UInt
  let trackName: String
  let artworkUrlString: String
  
  enum CodingKeys: String, CodingKey {
    case artistId, artistName, trackId, trackName
    case artworkUrlString = "artworkUrl100"
  }
}

struct AppleSearchResponse: Codable {
  let count: Int
  let matches: [ArtistMatches]
  
  enum CodingKeys: String, CodingKey {
    case count = "resultCount"
    case matches = "results"
  }
}

defaultSession.dataTask(with: url) { data, response, error in
  // Ensure 2XX response for success
  guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
    print("Invalid response")
    return
  }
  
  guard let data = data else {
    print("No data present")
    return
  }
  
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  
  if let result = try? decoder.decode(AppleSearchResponse.self, from: data) {
    print(result.matches[0...10])
    
    // Fetch artwork for first
    if let artistMatch = result.matches.first, let url = URL(string: artistMatch.artworkUrlString) {
      
      // Download image into memory
      defaultSession.dataTask(with: url) { data, response, error in
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print("Invalid response")
          return
        }
        
        guard let data = data else {
          print("No data present")
          return
        }
        
        let image = UIImage(data: data)
        let artwork = [image]
      }.resume()
      
      // Download image to file
      defaultSession.downloadTask(with: url) { url, response, error in
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print("Invalid response")
          return
        }
        
        guard let fileUrl = url else {
          print("Download didn't complete present")
          return
        }
        
        print(fileUrl.absoluteString)
      }.resume()
    }
  } else {
    print("Unable to parse data")
  }
}.resume()
