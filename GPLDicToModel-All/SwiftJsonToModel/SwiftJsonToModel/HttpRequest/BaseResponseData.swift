//
//  BaseResponseData.swift
//  SwiftJsonToModel
//
//  Created by 顾鹏凌 on 2017/12/22.
//  Copyright © 2017年 顾鹏凌. All rights reserved.
//

import UIKit

@objcMembers class BaseResponseData: NSObject {

}

class ProjectListCell: NSObject {
    @objc var comment:String = ""
    @objc var projectId:Int = 0
    @objc var name:String = ""
    @objc var url:String = ""
    
    override func smReplacedKey() -> [String : String] {
        return ["projectId":"id"]
    }

}

class UserInfoResponceData: NSObject {
    @objc var blog:String = ""
    @objc var name:String = ""
    @objc var projectListCell:Array<ProjectListCell> = [ProjectListCell]()
    
    override func smReplacedKey() -> [String : String] {
        return ["projectListCell":"projectList"]
    }
    
    override func smStatementKey() -> [String : String] {
        return ["projectListCell":ModelArr]
    }

}


////////////////////////////////////////////////
class BaseResponse: NSObject {
    @objc var error:Int = 0
    @objc var message:String = ""
    @objc var data:AnyObject?
    func success() -> Bool {
        return error == 1
    }
    func errorMessage() -> String {
        return message
    }
}

