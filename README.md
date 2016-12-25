# EMFileStream

A file operation tool developed by Swift 3 working on iOS, macOS and Linux.

#  中文介绍

你可以在[「这里」](http://enumsblog.com/post?pid=16011)找到中文介绍。

# Integration

Clone the repo and copy the framework to your project.

# Usage

Import the framework

```swift
import EMFileStream
```

## Read file:

Open a file like this:

```swift
let path = "path of a file"
let file = try EMFileStream.init(path: path, mode: .readBin)
//or let file = try EMFileStream.open(path: path, mode: .readBin)
```

Read some data:

```swift
let name = try file.readString(withSize: 20)
let age = try file.readInt()
let source = try file.readFloat()
let doubleSource = try file.readDouble()
```

Seek to some position:

```swift
try file.seek(100, withPosition: EMFileSeekPosition.set)
//EMFileSeekPosition.set = SEEK_SET
//EMFileSeekPosition.cur = SEEK_CUR
//EMFileSeekPosition.end = SEEK_END
```

Get the position in the file:

```swift
let pos = try file.tell()
```

Am I at the end of the file?

```swift
let result = try file.eof()
//End of file return false
//Not end of file return true
```

Close file:

```swift
try file.close()
//or just let ARC release the object, file will automatically close.
```

Reopen file:

```swift
try file.open()
```

## Write file:

Open or create a file like this:

```swift
let path = "path of a file"
let file = try EMFileStream.init(path: path, mode: .writeBin)
//or let file = try EMFileStream.open(path: path, mode: .writeBin)
```

Write something:

```swift
try stream.write(string: name, writeSize: 20)
try stream.write(int: age)
try stream.write(float: source)
try stream.write(double: doubleSource)
try stream.write(string: memo, writeSize: 100)
```

ps: Don't worry,  `fflush` will automatically called.

Close file:

```swift
try file.close()
//or just let ARC release the object, file will automatically close.
```



# HAVE FUN :)



