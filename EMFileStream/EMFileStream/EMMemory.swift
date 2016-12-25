//
//  EMMemory.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation

open class EMMemory: CustomDebugStringConvertible, CustomStringConvertible {
    
    open var mptr: UnsafeMutablePointer<UInt8>
    
    open var iptr: UnsafePointer<UInt8> {
        get {
            return UnsafePointer<UInt8>.init(mptr)
        }
    }
    
    open var data: Array<UInt8> {
        get {
            var data = Array<UInt8>.init(repeating: 0, count: size)
            for i in 0..<size {
                data[i] = mptr.advanced(by: i).pointee
            }
            return data
        }
    }
    open var size: Int = 0
    
    open var debugDescription: String {
        return "data size: \(size)"
    }
    
    open var description: String {
        return debugDescription
    }
    
    public init(size: Int) {
        self.mptr = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        self.size = size
    }
    
    public init(ptr: UnsafeMutablePointer<UInt8>, size: Int) {
        self.mptr = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        memcpy(self.mptr, ptr, size)
        self.size = size
    }
    
    deinit {
        mptr.deallocate(capacity: size)
    }
    
    open subscript(index: Int) -> UnsafeMutablePointer<UInt8> {
        return mptr.advanced(by: index)
    }
}
