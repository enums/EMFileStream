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

## Archive Your Object:

Use this two protocols:

```swift
public protocol EMFileStreamReadable {
    init(stream: EMFileStream) throws
}
public protocol EMFileStreamWriteable {
    func emObjectWrite(withStream stream: EMFileStream) throws
}
```

Then you can archive your own object to file with EMFileStream!

There is a Demo:

```swift
import Foundation
import EMFileStream

class Student: EMFileStreamReadable, EMFileStreamWriteable {
    
    var name: String
    var age: Int
    var source: Float
    var memo: String
    
    init(name: String, age: Int, source: Float, memo: String) {
        self.name = name
        self.age = age
        self.source = source
        self.memo = memo
    }
    
    required init(stream: EMFileStream) throws {
        self.name = try stream.readString(withSize: 20)
        self.age = try stream.readInt()
        self.source = try stream.readFloat()
        self.memo = try stream.readString(withSize: 100)
    }
    
    func emObjectWrite(withStream stream: EMFileStream) throws {
        try stream.write(string: name, writeSize: 20)
        try stream.write(int: age)
        try stream.write(float: source)
        try stream.write(string: memo, writeSize: 100)
    }   
}
```

Then you can archive and unarchive your object like this

```swift
let student = Student.init(name: "Sark", age: 20, source: 78.9, memo: "Memo..........")

do {
	//archive your object
    let saveFile = try EMFileStream.init(path: path, mode: .writeBin)
    try saveFile.write(object: student)
    //archive your object
    let readFile = try EMFileStream.init(path: path, mode: .readBin)
    let student = try readFile.readObject(cls: Student.self)
    
    print(student)
} catch {
    print(error)
}


```

# HAVE FUN :)



