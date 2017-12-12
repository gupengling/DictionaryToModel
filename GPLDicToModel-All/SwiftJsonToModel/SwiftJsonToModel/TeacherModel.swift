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

    override func tmReplacedKey() -> [String : String] {
        return ["coding":"code","classModel":"class","schoolModel":"school"]
    }
    
    override func tmStatementKey() -> [String : String] {
        return ["classModel":"AloneModel","schoolModel":"ModelArr"]
    }
//    override func tmStatementKey() -> [String : String] {
//        return ["schoolModel":"AloneModel"]
//    }
}
