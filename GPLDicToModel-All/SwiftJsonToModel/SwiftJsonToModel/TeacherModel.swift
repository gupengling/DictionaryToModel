//
//  TeacherModel.swift
//  SwiftJsonToModel
//
//  Created by GPL on 2017/12/11.
//  Copyright © 2017年 GPL. All rights reserved.
//

import UIKit

class TeacherModel: BaseModel {
    @objc var coding:Array<String> = [String]()
    @objc var classModel: ClassModel = ClassModel()
    @objc var schoolModel:Array<SchoolModel> = [SchoolModel]()

    override func smReplacedKey() -> [String : String] {
        return ["coding":"code","classModel":"class","schoolModel":"school"]
    }
    
    override func smStatementKey() -> [String : String] {
        return ["classModel":OnlyModel,"schoolModel":ModelArr]
    }
//    override func smStatementKey() -> [String : String] {
//        return ["schoolModel":OnlyModel]
//    }
}
