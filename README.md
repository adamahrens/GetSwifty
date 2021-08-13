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

`Combine` is the most recent which allows switching between threads with operations such as `subscribeOn` `receive`