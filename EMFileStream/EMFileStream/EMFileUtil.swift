//
//  EMFileUtil.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation


public enum EMFileMode: String {
    case writeBin = "wb"
    case readBin = "rb"
}

public enum EMFileSeekPosition: Int32 {
    case set = 0
    case cur = 1
    case end = 2
}


public let EM_SIZE_CHAR = 1
public let EM_SIZE_UINT8 = 1
public let EM_SIZE_INT = 4
public let EM_SIZE_UINT = 4
public let EM_SIZE_FLOAT = 4
public let EM_SIZE_DOUBLE = 8


fileprivate func swiftwrap_errormsg() -> String {
    return String.init(format: "%s", strerror(errno))
}

internal func swiftwrap_fopen(_ file: UnsafePointer<Int8>, _ mode: UnsafePointer<Int8>) throws -> UnsafeMutablePointer<FILE> {
    let fp = fopen(file, mode)
    guard fp != nil else {
        throw EMError.init(type: .fileOpenFailed, detail: "path: \(String.init(cString: file)), mode: \(String.init(cString: mode)), error: \(swiftwrap_errormsg())")
    }
    return fp!
}

internal func swiftwrap_fseek(_ fp: UnsafeMutablePointer<FILE>, _ size: Int, _ flag: Int32) throws {
    guard fseek(fp, size, flag) == 0 else {
        throw EMError.init(type: .fileSeekFailed, detail: "size: \(size), error: \(swiftwrap_errormsg())")
    }
}

internal func swiftwrap_fread(_ size: Int, _ count: Int, _ fp: UnsafeMutablePointer<FILE>) throws -> EMMemory {
    let aSize = size * count
    let memory = EMMemory.init(size: aSize)
    let rCount = fread(memory.mptr, size, count, fp)
    guard rCount == count else {
        throw EMError.init(type: .fileReadFailed, detail: "readCount: \(rCount)/\(count), error: \(swiftwrap_errormsg())")
    }
    return memory
}

internal func swiftwrap_fwrite(data: Data, fp: UnsafeMutablePointer<FILE>) throws {
    let size = data.count
    let bufferptr = UnsafeMutablePointer<Any>.allocate(capacity: size)
    defer {
        bufferptr.deallocate(capacity: size)
    }
    let byteptr = UnsafeMutableBufferPointer.init(start: bufferptr, count: size)
    _ = data.copyBytes(to: byteptr)
    let cPtr = UnsafeMutableRawPointer(bufferptr)
    try swiftwrap_fwrite(dataPtr: cPtr, size: size, fp: fp)
}

internal func swiftwrap_fwrite(dataPtr: UnsafeMutableRawPointer,
                               size: Int,
                               fp: UnsafeMutablePointer<FILE>) throws {
    let wSize = fwrite(dataPtr, 1, size, fp)
    guard wSize == size else {
        throw EMError.init(type: .fileReadFailed, detail: "writeCount: \(wSize)/\(size), error: \(swiftwrap_errormsg())")
    }
    fflush(fp)
}



internal func swiftwrap_fclose(_ fp: UnsafeMutablePointer<FILE>) throws {
    guard fclose(fp) == 0 else {
        throw EMError.init(type: .fileWriteFailed, detail: "error: \(swiftwrap_errormsg())")
    }
}

internal func swiftwrap_ftell(_ fp: UnsafeMutablePointer<FILE>) -> Int {
    return ftell(fp)
}

//End of file return false
//Not end of file return true
internal func swiftwrap_feof(_ fp: UnsafeMutablePointer<FILE>) -> Bool {
    _ = fgetc(fp)
    if feof(fp) == 0 {
        fseek(fp, -1, SEEK_CUR)
        return true
    } else {
        return false
    }
}
