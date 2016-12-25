//
//  EMError.swift
//  EMFileStream
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation


public enum EMErrorType: String {
    case none = "无错误"
    
    case fileOpened = "文件已被打开"
    case fileClosed = "文件已被关闭"
    case fileOpenFailed = "文件打开失败"
    case fileSeekFailed = "文件移动失败"
    case fileReadFailed = "文件读取失败"
    case fileWriteFailed = "文件写入失败"
    case fileCloseFailed = "文件关闭失败"
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
