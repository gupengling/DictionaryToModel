//
//  ClassModel.swift
//  SwiftJsonToModel
//
//  Created by GPL on 2017/12/11.
//  Copyright © 2017年 GPL. All rights reserved.
//

import UIKit

class ClassModel: NSObject {
    @objc var classId:Int = 0
    @objc var className:String = ""
    @objc var infoTestModel:InfoTestModel = InfoTestModel()

    override func smReplacedKey() -> [String : String] {
        return ["infoTestModel":"infoTest"]
    }

    override func smStatementKey() -> [String : String] {
        return ["infoTestModel":OnlyModel]
    }
}
