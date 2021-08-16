# GetSwifty
A Collection of Swift Learnings &amp; Tutorials

## Saving Data in iOS
Saving data in ios path from Ray Wenderlich

### FileManager

Handles managing files for you. Each iOS app has it's own sandbox for storing files. `FileManager` is thread safe. Use the `URL` struct for dealing with files, directories, and paths.

A `URL` `path` is string. To add a file use `.appendingPathComponent` for the filename and use `appendingPathExtension` for the type of file it would be, such as `.json` or `.txt`.

You can use `.lastPathComponent` on a `URL` to get the filename with extension

### JSON

Popular format for sending data over the web. Also viable for saving data on an iOS object. It only supports a few data types natively such as `Bool, Integer, String, Array`

### Plist

Essentially like `XML` document. They always have a `.plist` extension. Saving a plist of similiar `JSON` information but will inherently require more space.

## Networking with URLSession

Used to have to use `NSURLConnection` but Apple released in iOS 7 `URLSession`. Sits on top of Apple's networking stack.

### Concurrency & DataTasks

Doing multiple things at once (log events, pull data, save to disk, etc). Path of execution is a `Thread`. 

We could work directly with threads such as `NSThread`. Which can be harder. Another low level framework is `GCD` or `Grand Central Dispatch`. They use a `FIFO` order when executing work.

`OperationQueue` is another higher level framework built on top of `GCD`. It allows setting up depdencies and cancel operations easily.

Instead of just creating numerous `Operation` subclasses can just use closures with `OperationQueue#addOperation` or use the provided `BlockOperation` subclass that takes a closure in the `init`

`Combine` is the most recent which allows switching between threads with operations such as `subscribeOn` `receive`

The `Main` thread is not designed for concurrent threads to access it.

`URLSessionConfiguration` is used to configure how you want your `URLSession` to behave. Want it in privacy mode? Run on background threads? Store credentials?. It comes with a `default`, `empheral` is almost like incognito. It won't store cookies or cache to disk.

All configurations must be done before creating the `URLSession`. Updates after the fact do nothing.

In order to perform work you have to pass `URLSessionTask` to the `URLSession` these could be `dataTask` or `downloadTask` or `uploadTask`. 

* `DataTask` response returned in memory
* `UploadTask` similar to datatask but easier to provide request body
* `DownloadTask` response is written to file. Useful for downloading images, audio, videos

You must call `resume` on all tasks since they start in a waiting state.

### Downloading & Uploading

When downloading/uploading is crucial to understand priorities & cachce policies.

Priority suggestion helps determine how the OS should handle the request. If that data isn't important the system might not execute immediately. Priority goes from `0-1` with options such as `defaultPriority`, `lowPriority: 0`, and `.highPriority: 1`

Can also cache response to continually return it. 

Both Download and Upload have delegate callbacks for details on task. Can use those to present progressViews or other detailed information.

`NetworkLinkConditioner` can be used to simulate your network speeds. Download from Apple Developer Tools

Network tasks provide the ability to cancel, pause, and resuming. When you `pause` store the provided `Data` to then pass to `resume`

### Background Downloading & Websockets

Aside from the `Data`, `Upload` and `Download` tasks. We have two additional ones for `WebSocket` and `Stream`.

In order to support your app to download in the background. You need to configure your `URLSessionConfig.networkServiceType` to be of `.background`. You'll need to implement the `delegate` methods. iOS will eventually call an `AppDelegate` callback.

### URLSession & Combine