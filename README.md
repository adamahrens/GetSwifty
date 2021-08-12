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