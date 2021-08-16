/// Copyright (c) 2020 Razeware LLC
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

struct SongDetailView: View {

  @Binding var musicItem: MusicItem
  @State private var playMusic = false
  @State private var musicImage = UIImage(named: "c_urlsession_card_artwork")!
  @ObservedObject var songDownloader = SongDownload()
  
  /// Attempts to download iTunes preview mp3 if it hasn't already fetched it
  private func attemptDownload() {
    // Ensure we have a previewUrl to fetch from and
    // we haven't already downloaded it.
    guard
      let previewUrl = musicItem.previewUrl, songDownloader.downloadedLocation == nil
    else {
      // We can play the downloaded preview
      playMusic = true
      return
    }
    
    switch songDownloader.state {
      case .waiting:
        songDownloader.fetchSong(at: previewUrl)
      case .downloading:
        songDownloader.pause()
      case .paused:
        songDownloader.resume()
      case .finished:
        playMusic = true
    }
  }
  
  private func fetchAlbumArt() {
    guard
      let url = URL(string: musicItem.artwork)
    else { return }
    
    URLSession.shared.downloadTask(with: url) { locationUrl, response, error in
      if let e = error {
        print("Error downloading image \(e)")
      }
      
      if let location = locationUrl,
         let data = try? Data(contentsOf: location),
         let image = UIImage(data: data) {
        musicImage = image
      }
    }.resume()
  }
  
  var body: some View {
    VStack {
      GeometryReader { reader in
        VStack {
          Image(uiImage: musicImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: reader.size.height / 2)
            .cornerRadius(50)
            .padding()
            .shadow(radius: 10)
          Text("\(self.musicItem.trackName) - \(self.musicItem.artistName)")
          Text(self.musicItem.collectionName)
          
          if songDownloader.state == SongDownload.DownloadState.downloading || songDownloader.state == SongDownload.DownloadState.paused {
            ProgressView("Downloading...", value: songDownloader.downloadedAmount, total: 1.0)
              .padding()
          }

          Button(action: attemptDownload) {
            Text(songDownloader.downloadedLocation == nil ? "Download" : "Listen")
          }
        }
      }
    }
    .onAppear(perform: fetchAlbumArt)
    .sheet(isPresented: $playMusic, content: {
      AudioPlayer(songUrl: songDownloader.downloadedLocation!)
    })
  }  
}


struct SongDetailView_Previews: PreviewProvider {
  
  struct PreviewWrapper: View {
    @State private var musicItem = MusicItem(id: 192678693, artistName: "Leonard Cohen", trackName: "Hallelujah", collectionName: "The Essential Leonard Cohen", preview: "https://audio-ssl.itunes.apple.com/itunes-assets/Music/16/10/b2/mzm.muynlhgk.aac.p.m4a", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/77/17/ab/7717ab31-46f9-48ca-7250-9f565306faa7/source/1000x1000bb.jpg")
    
    var body: some View {
      SongDetailView(musicItem: $musicItem)
    }
  }
  
  static var previews: some View {
    PreviewWrapper()
  }
}

