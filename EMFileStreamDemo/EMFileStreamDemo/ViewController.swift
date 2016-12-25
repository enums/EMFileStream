//
//  ViewController.swift
//  EMFileStreamDemo
//
//  Created by 郑宇琦 on 2016/12/24.
//  Copyright © 2016年 Enum. All rights reserved.
//

import UIKit
import EMFileStream

class ViewController: UIViewController {
    
    let path = NSHomeDirectory() + "/Documents/test.txt"

    override func viewDidLoad() {
        super.viewDidLoad()
        let student = Student.init(name: "Sark", age: 20, source: 78.9, doubleSource: 90.12345, memo: "Memo..........")
        do {
            let file = try EMFileStream.init(path: path, mode: .writeBin)
            try file.write(object: student)
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            let file = try EMFileStream.init(path: path, mode: .readBin)
            let student = try file.readObject(cls: Student.self)
            print(student)
        } catch {
            print(error)
        }
    }


}

