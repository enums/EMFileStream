//
//  EMError.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation


public enum EMErrorType: String {
    case none = "No Error"
    
    case fileOpened = "File already opened"
    case fileClosed = "File already closed"
    case fileOpenFailed = "File open failed"
    case fileSeekFailed = "File seek failed"
    case fileReadFailed = "File read failed"
    case fileWriteFailed = "File write failed"
    case fileCloseFailed = "File close failed"
}


open class EMError: Error, CustomStringConvertible {
    
    open var name: String
    open var detail: String
    
    public var description: String {
        return "name: \(name), detail: \(detail)"
    }
    
    public init(type: EMErrorType, detail: String) {
        name = type.rawValue
        self.detail = detail
    }
}
