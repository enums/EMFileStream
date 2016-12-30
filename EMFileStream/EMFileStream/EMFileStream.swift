//
//  EMFileStream.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation

fileprivate enum EMFileStreamStatus {
    case open
    case close
}

open class EMFileStream {
    
    fileprivate var path: String
    fileprivate var mode: EMFileMode
    
    fileprivate var fp: UnsafeMutablePointer<FILE>
    fileprivate var status: EMFileStreamStatus
    
    
    public init(path: String, mode: EMFileMode) throws {
        self.path = path
        self.mode = mode
        fp = try swiftwrap_fopen(path, mode.rawValue)
        status = .open
    }
    
    open static func open(path: String, mode: EMFileMode) throws -> EMFileStream {
        return try EMFileStream.init(path: path, mode: mode)
    }
    
    
    //MARK: - Standard
    open func open() throws {
        try guardSelfClose()
        fp = try swiftwrap_fopen(path, mode.rawValue)
        status = .open
    }
    
    open func read(size: Int, count: Int) throws -> EMMemory {
        try guardSelfOpen()
        return try swiftwrap_fread(size, count, fp)
    }
    
    open func seek(size: Int, withPosition pos: EMFileSeekPosition) throws {
        try guardSelfOpen()
        return try swiftwrap_fseek(fp, size, pos.rawValue)
    }
    
    open func write(data: Data) throws {
        try guardSelfOpen()
        return try swiftwrap_fwrite(data: data, fp: fp)
    }
    
    open func write(dataPtr: UnsafeMutableRawPointer, size: Int) throws {
        try guardSelfOpen()
        return try swiftwrap_fwrite(dataPtr: dataPtr, size: size, fp: fp)
    }
    
    open func close() throws {
        try guardSelfOpen()
        try swiftwrap_fclose(fp)
        status = .close
    }
    
    open func tell() throws -> Int {
        return swiftwrap_ftell(fp)
    }
    
    open func eof() throws -> Bool {
        try guardSelfOpen()
        return swiftwrap_feof(fp)
    }
    
    deinit {
        try? swiftwrap_fclose(fp)
    }
    
    //MARK: - Extension Seek
    open func seekInt() throws {
        try guardSelfOpenAndReadable()
        try seek(size: EM_SIZE_INT, withPosition: .cur)
    }
    
    open func seekUInt() throws {
        try guardSelfOpenAndReadable()
        try seek(size: EM_SIZE_UINT, withPosition: .cur)
    }
    
    open func seekUInt8() throws {
        try guardSelfOpenAndReadable()
        try seek(size: EM_SIZE_UINT8, withPosition: .cur)
    }
    
    open func seekFloat() throws {
        try guardSelfOpenAndReadable()
        try seek(size: EM_SIZE_FLOAT, withPosition: .cur)
    }
    
    open func seekDouble() throws {
        try guardSelfOpenAndReadable()
        try seek(size: EM_SIZE_DOUBLE, withPosition: .cur)
    }
    
    //MARK: - Extension Read
    open func readInt() throws -> Int {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_INT, count: 1)
        return Int.gen(ptr: memory.mptr)
    }
    
    open func readUInt() throws -> UInt {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_UINT, count: 1)
        return UInt.gen(ptr: memory.mptr)
    }
    
    open func readUInt8() throws -> UInt8 {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_UINT8, count: 1)
        return UInt8.gen(ptr: memory.mptr)
    }
    
    open func readFloat() throws -> Float {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_FLOAT, count: 1)
        return Float.gen(ptr: memory.mptr)
    }
    
    open func readDouble() throws -> Double {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_DOUBLE, count: 1)
        return Double.gen(ptr: memory.mptr)
    }
    
    open func readString(withSize size: Int) throws -> String {
        try guardSelfOpenAndReadable()
        let memory = try read(size: EM_SIZE_CHAR, count: size)
        return String.gen(ptr: try memory.mptr)
    }
    
    open func readObject(cls: EMFileStreamReadable.Type) throws -> EMFileStreamReadable {
        try guardSelfOpenAndReadable()
        return try cls.emObjectRead(withStream: self)
    }
    
    //MARK: - Extension Write
    open func write(int: Int) throws {
        try guardSelfOpenAndWriteable()
        var _int = int
        try write(dataPtr: &_int, size: EM_SIZE_INT)
    }
    
    open func write(uint: UInt) throws {
        try guardSelfOpenAndWriteable()
        var _uint = uint
        try write(dataPtr: &_uint, size: EM_SIZE_UINT)
    }
    
    open func write(uint8: UInt8) throws {
        try guardSelfOpenAndWriteable()
        var _uint8 = uint8
        try write(dataPtr: &_uint8, size: EM_SIZE_UINT8)
    }
    
    open func write(float: Float) throws {
        try guardSelfOpenAndWriteable()
        var _float = float
        try write(dataPtr: &_float, size: EM_SIZE_FLOAT)
    }
    
    open func write(double: Double) throws {
        try guardSelfOpenAndWriteable()
        var _double = double
        try write(dataPtr: &_double, size: EM_SIZE_DOUBLE)
    }
    
    open func write(string: String, writeSize: Int? = nil) throws {
        try guardSelfOpenAndWriteable()
        guard var cStr = string.cString(using: .utf8) else {
            throw EMError.init(type: .fileWriteFailed, detail: "String encoding failed!")
        }
        try write(dataPtr: &cStr, size: writeSize ?? cStr.count)
    }

    
    open func write(object: EMFileStreamWriteable) throws {
        try guardSelfOpenAndWriteable()
        try object.emObjectWrite(withStream: self)
    }
    
    //MARK: - Guard Self
    fileprivate func guardSelfOpenAndWriteable() throws {
        try guardSelfOpen()
        guard mode == .writeBin else {
            throw EMError.init(type: .fileClosed, detail: "File mode error!")
        }
    }
    
    fileprivate func guardSelfOpenAndReadable() throws {
        try guardSelfOpen()
        guard mode == .readBin else {
            throw EMError.init(type: .fileClosed, detail: "File mode error!")
        }
    }
    
    fileprivate func guardSelfOpen() throws {
        guard status == .open else {
            throw EMError.init(type: .fileClosed, detail: "File already closed!")
        }
    }
    
    fileprivate func guardSelfClose() throws {
        guard status == .close else {
            throw EMError.init(type: .fileOpened, detail: "File already opened!")
        }
    }
    
}

