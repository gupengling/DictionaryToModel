//
//  HttpServiceEngine.swift
//  SwiftJsonToModel
//
//  Created by 顾鹏凌 on 2017/12/22.
//  Copyright © 2017年 顾鹏凌. All rights reserved.
//

import UIKit
enum HttpKindStyle : NSString {
    case Post = "Post"
    case PostJson = "PostJson"
    case Get = "Get"
}
let HttpRequestTimeOut:Int = 30

class HttpServiceEngine: NSObject {
    static let shareInstance = HttpServiceEngine()
    var session:URLSession = URLSession.shared
    
    func asyncGetRequest(req:BaseRequest) {
        self.asyncRequest(req: req, style: .Get)
    }
    func asyncPostJsonRequest(req:BaseRequest) {
        self.asyncRequest(req: req, style: .PostJson)
    }
    func asyncRequest(req:BaseRequest,style:HttpKindStyle) {
        DispatchQueue.global(qos: .default).async {
            let url = req.url()
            print(">>>>>请求接口\(url)")
            if url.lengthOfBytes(using: String.Encoding.utf8) < 1 {
                print(">>>>>请求url错误\(url)")
                return
            }
            
            let request:NSMutableURLRequest = NSMutableURLRequest.init()
            if style == .PostJson {
                request.url = NSURL.init(string: url)! as URL
//                request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
                let data:NSData = (req.toPostJsonData())! as NSData
                
                request.httpMethod = "POST"
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
                request.httpBody = data as Data

                
            }else if style == .Get {
//                request = NSMutableURLRequest.init(url: NSURL.init(string: req.toGetUrlString())! as URL)
                request.url = NSURL.init(string: req.toGetUrlString())! as URL

                request.httpShouldHandleCookies = false
                request.httpMethod = "GET"
            }
            request.timeoutInterval = TimeInterval(HttpRequestTimeOut)
            
            print(">>>>>正在请求接口\(style)")

            let dataTask:URLSessionDataTask = self.session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                print(">>>>>请求接口完成\n")
                if (data != nil) {
                    let responseData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    req.parseResponse(respJsonObject: responseData as AnyObject)
                }else {
                    DispatchQueue.main.async(execute: {
                        req.resopnse.error = -1
                        req.resopnse.message = "返回数据非Json格式"
                        req.failBlock!(req)
                    })
                }
            })
            dataTask.resume()
        }
    }
}
