//
//  SongDownload.swift
//  HalfTunes
//
//  Created by Adam Ahrens on 8/13/21.
//  Copyright © 2021 raywenderlich. All rights reserved.
//

import SwiftUI
import Foundation

typealias SongDownloadCompletion = (() -> Void)

final class SongDownload: NSObject, ObservableObject {
  var downloadTask: URLSessionDownloadTask?
  var downloadUrl: URL?
  
  /// Used for when we attempt to pause a download
  private var resumedData: Data?
  
  /// URLSession that supports background downloading
  private var session: URLSession!
  
  /// Used for supporting background sessions
  var completionHandler: SongDownloadCompletion?
    
  /// Set once a download is complete
  @Published var downloadedLocation: URL?
  
  /// How much has been downloaded
  @Published var downloadedAmount = Float(0)
  
  /// Tracking the state of the download
  @Published var state = DownloadState.waiting
  
//
//  Before using background downloads
//
//  lazy var session: URLSession = {
//    let config = URLSessionConfiguration.default
//    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
//  }()
  
  override init() {
    super.init()
    
    let config = URLSessionConfiguration.background(withIdentifier: "com.appsbyahrens.background")
    session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
  }
  
  /// Fetches the mp3 file at a specified URL
  func fetchSong(at url: URL) {
    downloadUrl = url
    downloadTask = session.downloadTask(with: url)
    downloadTask?.resume()
    state = DownloadState.downloading
  }
  
  /// Cancels a download
  func cancel() {
    state = DownloadState.waiting
    downloadedAmount = 0
    downloadTask?.cancel()
  }
  
  /// Pause a download
  func pause() {
    state = DownloadState.paused
    downloadTask?.cancel(byProducingResumeData: { [weak self] data in
      self?.resumedData = data
    })
  }
  
  /// Add ability to resume a download
  func resume() {
    guard let data = resumedData else { return }
    downloadTask = session.downloadTask(withResumeData: data)
    downloadTask?.resume()
    state = DownloadState.downloading
  }
  
  /// Download State
  enum DownloadState {
    case waiting, downloading, paused, finished
  }
}


// MARK: URLSessionDelegate (For Background Downloads)
extension SongDownload: URLSessionDelegate {
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    guard let completion = completionHandler else { return }
    
    DispatchQueue.main.async {
      print("Calling SongDownload completiong handler")
      completion()
    }
  }
}

// MARK: URLSessionDownloadDelegate
extension SongDownload: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    print("DownloadTask#didFinishDownloading to \(location.absoluteString)")
    
    OperationQueue.main.addOperation { [weak self] in
      self?.state = DownloadState.finished
    }
    
    
    guard
      let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
      let lastPathComponent = downloadUrl?.lastPathComponent
    else { return }
    
    let destination = documents.appendingPathComponent(lastPathComponent)
    
    do {
      try FileManager.default.removeItem(at: destination)
      try FileManager.default.copyItem(at: location, to: destination)
      
      /// Ensure it's done on the main thread
      OperationQueue.main.addOperation {
        self.downloadedLocation = destination
      }
    } catch {
      print("Unable to save from temp to documents directory \(error)")
    }
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    let errorMessage = error?.localizedDescription ?? "Download task completed"
    print("DownloadTask#didCompleteWithError \(errorMessage)")
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    // Cacluate percentage downloading
    DispatchQueue.main.async {
      self.downloadedAmount = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      print("Percentage downloaded = \(self.downloadedAmount)")
    }
  }
}
