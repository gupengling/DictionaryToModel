//
//  DicToModel.swift
//  SwiftJsonToModel
//
//  Created by GPL on 2017/11/10.
//  Copyright © 2017年 GPL. All rights reserved.
//

import Foundation
enum ModelType : NSString {
    case Normal = "Normal"
    case ModelArr = "ModelArr"
    case Model = "Model"
}

let OnlyModel:String = "OnlyModel"
let ModelArr:String = "ModelArr"

//    class func objectWithKeyValues(keyValues:NSDictionary) -> AnyObject{
//        let model = self.init()
//
//        //存放属性的个数
//        var outCount:UInt32 = 0
//        //获取所有的属性
////        let properties = class_copyPropertyList(self, &outCount)
//        let properties = class_copyPropertyList(self.classForCoder(), &outCount)
//        //遍历属性
////        var i = 0
//        for  i in 0 ..< outCount   {
////        for var i:Int = 0;i < Int(outCount); ++i  {
//            //获取第i个属性
//            let property = properties![Int.init(i)]
//            //得到属性的名字//NSUTF8StringEncoding
//            let key = NSString.init(cString: property_getName(property), encoding: String.Encoding.utf8.rawValue)
////            let key = NSString.init(CString: property_getName(property), encoding:NSUTF8StringEncoding)!
//            if let value = keyValues[key as Any]{
//                //为model类赋值
//                model.setValue(value, forKey: key! as String)
//            }
//        }
//        return model
//    }
//
//    func toDictionary(from classType: NSObject.Type) -> [String: Any] {
//
//        var propertiesCount : CUnsignedInt = 0
//        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
//        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
//
//        for i in 0 ..< Int(propertiesCount) {
//            let property = propertiesInAClass?[i]
//            let strKey = NSString(utf8String: property_getName(property!)) as String?
//            if let key = strKey {
//                propertiesDictionary.setValue(self.value(forKey: key), forKey: key)
//            }
//        }
//        return propertiesDictionary as! [String : Any]
//    }

//}


extension NSObject{
    @objc func smStatementKey() ->[String:String]{
        return ["":""]
    }
    
    @objc func smReplacedKey() ->[String:String]{
        return ["":""]
    }
    
    /// 字典转模型
    ///
    /// - Parameter keyValues: 原数据字典
    /// - Returns: 转换后的模型
    class func objectWithKeyValues(keyValues:Dictionary<String, AnyObject>) -> AnyObject {
        let model = self.init()
        let properties = AllProperties(self)
        model.setValuesForProperties(properties, keyValues: keyValues)
        return model;
    }
    
    /// 数组转模型数组
    ///
    /// - Parameter array: 原数据数组
    /// - Returns: 转换后的模型数组
    class func objectArrayForModelArr(_ array:Array<Any>) -> [AnyObject]{
        return objectArrayWithKeyValuesArray(array , self)
    }
    
    private class func objectArrayWithKeyValuesArray(_ array:Array<Any> , _ currentClass:AnyClass) -> [AnyObject]{
        var temp = Array<AnyObject>()
        let properties = self.AllProperties(currentClass)
        for item in array{
            let keyValues = item as? NSDictionary
            if (keyValues != nil){
                let model = self.init()
                //为每个model赋值
                model.setValuesForProperties(properties, keyValues: keyValues! as! Dictionary<String, AnyObject>)
                temp.append(model)
            }
        }
        return temp
    }
    
    //获取所有属性名
    class func AllProperties(_ typeClass: AnyClass) -> [GPLProperty]? {
        guard let className  = NSString(cString: class_getName(typeClass), encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        
        if className.isEqual(to: "NSObject") {
            return nil
        }

        let my = self.init()
        let statementDict = my.smStatementKey()
        let replaceDic = my.smReplacedKey()

        var propertiesArray = [GPLProperty]()
        let tmSuperClass =  typeClass.superclass() as! NSObject.Type
        

        let superM = AllProperties(tmSuperClass)
        if let _ = superM {
            propertiesArray += superM!
        }

        var count : UInt32 = 0
        let ivars = class_copyIvarList(typeClass, &count)!
        
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            propertiesArray.append(GPLProperty(ivar,statementDict, replaceDic))
        }
        free(ivars)
        return propertiesArray
    }
    
    //赋值
    func setValuesForProperties(_ properties:[GPLProperty]?,keyValues:Dictionary<String, AnyObject>){
        guard (properties != nil) else {
            return
        }
        var currentDict = keyValues
//        print(currentDict)

        for property in properties!{
            
            if property.modelType ==  .Model {
                guard let value = currentDict[property.property] else {
                    debugPrint("Debug: " + property.propertyName + "检测出空值")
                    return
                }
                let currentModel = property.typeClass as! NSObject.Type
                self.setValue(currentModel.objectWithKeyValues(keyValues: value as! Dictionary<String, AnyObject>), forKey: property.propertyName)

//                currentDict = value as! [String : AnyObject]//字典套字典使用，有个问题
            }
            else if (property.modelType ==  .ModelArr) {
                if property.typeClass  == nil {
                    debugPrint("Debug: " + property.propertyName + " key与你创建的类不一致")
                    return
                }
                let value = currentDict[property.property]
                if value == nil {
                    continue
                }
                let currentModel = property.typeClass as! NSObject.Type
                let currentArr = currentModel.objectArrayForModelArr(value as! Array )
                self.setValue(currentArr, forKey: property.propertyName)
            }
            else {
                guard let value = currentDict[property.property] else {
                    debugPrint("Debug: " + "\(property.propertyName)" + "模型与字典的key不匹配")
                    return
                }
                let type = NSStringFromClass(object_getClass(value)!)
                if type != "NSNull" {
                    self.setValue(value, forKey: property.propertyName as String)
                }else {
                    debugPrint("Debug: " + "\(property.propertyName)" + "值为nil")
                }

            }
            
        }
    }
    
}
    
class GPLProperty{
    var propertyName:String!
    var property:String!
    var modelType:ModelType = .Normal
    var typeClass:AnyClass?

    init(_ tmProperty:objc_property_t ,_ dict:Dictionary<String, String> , _ rdict:Dictionary<String, String>){
        let name = ivar_getName(tmProperty)
        self.propertyName = String(cString: name!)
        self.analysisTMModel(values: self.propertyName, dict, rdict)

    }
    
    //判断是否是自定义类型
    private func analysisTMModel(values:String , _ dict:Dictionary<String, String>, _ rdict:Dictionary<String, String>)  {
        self.property =  self.propertyName
        
        let newValues = dict[values]
        
        let repalceValue = rdict[values]
        
        if (repalceValue != nil) {
            self.property =  repalceValue!
        }
        
        if (newValues != nil) {
            let value = dict[values]!
            if value.contains(OnlyModel) {
                self.modelType = .Model
            }
            if value.contains(ModelArr) {
                self.modelType = .ModelArr
            }
            let className = smFristCapitalized(str: self.propertyName)
            self.typeClass =   NSClassFromString(smGetBundleName() + "." + className)
        }
    }
    
    //首字母大写
    fileprivate func smFristCapitalized(str:String) -> String {
        var noNumber:String = ""
        var i = 0
        
        let c = str.startIndex
        for char in str[c ..< str.endIndex] {
            
//        for char in (str as String).characters {//用上面形式替换已废弃的方法
            if i == 0 {
                let str = String(char).uppercased()
                noNumber = str
            }else {
                noNumber += String(char)
            }
            i = i+1
        }
        return noNumber
    }
    
    //获取工程的名字
    fileprivate func smGetBundleName() -> String{
        var bundlePath = Bundle.main.bundlePath
        bundlePath = bundlePath.components(separatedBy: "/").last!
        bundlePath = bundlePath.components(separatedBy: ".").first!
        return bundlePath
    }
    
}


