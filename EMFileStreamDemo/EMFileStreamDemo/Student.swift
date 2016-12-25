//
//  Student.swift
//  EMFileStreamDemo
//
//  Created by 郑宇琦 on 2016/12/25.
//  Copyright © 2016年 Enum. All rights reserved.
//

import Foundation
import EMFileStream

class Student: CustomStringConvertible, EMFileStreamReadable, EMFileStreamWriteable {
    
    var name: String
    var age: Int
    var source: Float
    var doubleSource: Double
    var memo: String
    
    var description: String {
        return "name: \(name), age: \(age), source: \(source), doubleSource: \(doubleSource), memo: \(memo)"
    }
    
    init(name: String, age: Int, source: Float, doubleSource: Double, memo: String) {
        self.name = name
        self.age = age
        self.source = source
        self.doubleSource = doubleSource
        self.memo = memo
    }
    
    func emObjectWrite(withStream stream: EMFileStream) throws {
        try stream.write(string: name, writeSize: 20)
        try stream.write(int: age)
        try stream.write(float: source)
        try stream.write(double: doubleSource)
        try stream.write(string: memo, writeSize: 100)
    }
    
    static func emObjectRead(withStream stream: EMFileStream) throws -> EMFileStreamReadable {
        let name = try stream.readString(withSize: 20)
        let age = try stream.readInt()
        let source = try stream.readFloat()
        let doubleSource = try stream.readDouble()
        let memo = try stream.readString(withSize: 100)
        return Student.init(name: name, age: age, source: source, doubleSource: doubleSource, memo: memo)
    }
}
