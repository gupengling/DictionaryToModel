//
//  BaseRequest.swift
//  SwiftJsonToModel
//
//  Created by GPL on 2017/12/22.
//  Copyright © 2017年 GPL. All rights reserved.
//

import UIKit

typealias RequestBlock = (_ req:BaseRequest) -> Void;

class UserInfoRequest: BaseRequest {
    var requestParm:Dictionary<String, AnyObject>?

    override func url() -> String {
        let host = hostUrl()
        let url = host.appending("/method")
        return url
    }
    override func packageParams() -> Dictionary<String, AnyObject> {
        return requestParm!
    }
    
    override func parseResopnseData(dic: Dictionary<String, AnyObject>) -> AnyObject {
        return UserInfoResponceData.objectWithKeyValues(keyValues:dic) as! UserInfoResponceData
    }
}

////////////////////////////////////////////////////
class BaseRequest: NSObject {
    var succBlock:RequestBlock?
    var failBlock:RequestBlock?
    
    var resopnse:BaseResponse = BaseResponse()
    // MARK: 初始化方法
    override init() {
        super.init()
    }
    func initWithBlock(success: @escaping RequestBlock) {
        self.succBlock = success
    }
    func initWithBlock(success: @escaping RequestBlock,fail: @escaping RequestBlock) {
        self.initWithBlock(success: success)
        self.failBlock = fail
    }
    
    // MARK:  基础配置
    func hostUrl() -> String {
        return "http://api.nohttp.net"
    }
    func url() -> String {
        assert(false, "需要重写 - url()")
        return ""
    }
    func packageParams() -> Dictionary<String,AnyObject> {
        assert(false, "需要重写 - packageParams()")
        return ["":"" as AnyObject]
    }
    func responseClass()->BaseResponse{
        return BaseResponse()
    }
    func responseDataClass()->AnyObject{
        return BaseResponseData()
    }

    // MARK:  解析器
    func parseResponse(respJsonObject:AnyObject) {
        print("<<<<<<[\(self)]收到数据准备解析\n\(respJsonObject)\n")
        print("<<<<<<< 正在解析 所有数据")
        DispatchQueue.global(qos: .default).async {
            if (respJsonObject != nil) {
                if ( respJsonObject.isKind(of: NSDictionary.classForCoder()) ){
                    self.parseDictionaryResponse(dataDic: respJsonObject as! NSDictionary)
                }else {
                    DispatchQueue.main.async {
                        print("<<<<<<<解析完成[\(self)]\n")
                        print("<<<<<<< 数据异常")
                        if (self.failBlock != nil ) {
                            self.failBlock!(self)
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    print("<<<<<<< 解析完成[\(self)]\n")
                    if self.resopnse.success() {
                        if self.succBlock != nil {
                            self.succBlock!(self)
                        }
                    }else {
                        print("业务数据错误 -> \(self.resopnse.errorMessage())\n")
                        if (self.failBlock != nil ) {
                            self.failBlock!(self)
                        }
                    }
                }
            }else {
                DispatchQueue.main.async {
                    print("<<<<<<<解析完成[\(self)]\n")
                    if (self.failBlock != nil ) {
                        self.failBlock!(self)
                    }
                }

            }
        }
    }
    
    
    func parseDictionaryResponse(dataDic:NSDictionary) {
        self.resopnse = self.responseClass()
        resopnse.error = dataDic.object(forKey: "error") as! Int
        if ( dataDic.allKeys.contains(where: { (result) -> Bool in
            return result as! String == "message"
        }) ){
            resopnse.message = dataDic.object(forKey: "message") as! String
        }
        if ( dataDic.allKeys.contains(where: { (result) -> Bool in
            return result as! String == "data"
        }) ){
            let dic:Dictionary<String,AnyObject> = dataDic.object(forKey: "data") as! Dictionary<String, AnyObject>
            print("<<<<<<< 正在解析 data 数据\n\(dic)\n")
            resopnse.data = self.parseResopnseData(dic: dic )
        }

    }
    
    func parseResopnseData(dic:Dictionary<String,AnyObject>) -> AnyObject {
        assert(false, "需要重写 - parseResopnseData(dic:)")
        return BaseResponseData()
    }
    
    // MARK:  工具类
    func toPostJsonData() -> NSData? {
        let dic:NSDictionary = self.packageParams() as NSDictionary
        if JSONSerialization.isValidJSONObject(dic) {
            let data:NSData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) as NSData//JSONSerialization.WritingOptions
            if (data != nil) {
                return data as NSData
            }else {
                print("数据错误\(dic)")
            }
        }
        return nil
    }
    
    func toGetUrlString() -> String {
        let url:String = self.url()
        let muUrl:NSMutableString = NSMutableString.init(string: url)
        muUrl.append("?")
        let dic:NSDictionary = self.packageParams() as NSDictionary
        let keys:NSArray = dic.allKeys as NSArray
        let count:Int = dic.allKeys.count
        for  i in 0 ..< count {
            let key:String = keys.object(at: i) as! String
            let value:String = dic.object(forKey: key) as! String
            muUrl.appendFormat("%@=%@&", key,value)
        }
        return String.init(muUrl)
    }
    
    
}
