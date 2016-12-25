//
//  EMFileStreamExtension.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation


internal extension Int {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> Int {
        var ret = 0
        memcpy(&ret, ptr, EM_SIZE_INT)
        return ret
    }
}

internal extension UInt {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> UInt {
        var ret: UInt = 0
        memcpy(&ret, ptr, EM_SIZE_UINT)
        return ret
    }
}

internal extension UInt8 {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> UInt8 {
        var ret: UInt8 = 0
        memcpy(&ret, ptr, EM_SIZE_UINT8)
        return ret
    }
}

internal extension Float {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> Float {
        var ret: Float = 0
        memcpy(&ret, ptr, EM_SIZE_FLOAT)
        return ret
    }
}

internal extension Double {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> Double {
        var ret: Double = 0
        memcpy(&ret, ptr, EM_SIZE_DOUBLE)
        return ret
    }
}

internal extension String {
    internal static func gen(ptr: UnsafeMutablePointer<UInt8>) -> String {
        return String.init(cString: ptr)
    }
}
