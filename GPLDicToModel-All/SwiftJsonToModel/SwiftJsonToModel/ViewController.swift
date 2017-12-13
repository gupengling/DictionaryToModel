//
//  ViewController.swift
//  SwiftJsonToModel
//
//  Created by GPL on 2017/11/10.
//  Copyright © 2017年 GPL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.func1()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func func1(){
        
        let dict = ["age":24,
                    "name":"阿花",
                    "sex":true,
                    "code":["英语","java","php","swift"],
                    "class":["classId":110,"className":"12年级","infoTest":["infoId":25,"infoName":"花花"]],
                    "school":[["schoolId":10000,
                              "schoolName":"牛逼小学"],
                              ["schoolId":10001,
                               "schoolName":"牛逼大学"]],
                    ] as [String : AnyObject]
        let teacher:TeacherModel = TeacherModel.objectWithKeyValues(keyValues: dict) as! TeacherModel
        
        
        print("age = \(teacher.age) "+"name = \(teacher.name) "+"sex = \(teacher.sex) "+"coding = \(teacher.coding) "+"classId = \(teacher.classModel.classId) "+"className = \(teacher.classModel.className)"+"infoId = \(teacher.classModel.infoTestModel.infoId) "+"infoName=\(teacher.classModel.infoTestModel.infoName) ")
        
        
        let c:Int = teacher.schoolModel.count
        for i in 0 ..< c {
            let sm:SchoolModel = teacher.schoolModel[i]
            print("\(sm.schoolId) "+"\(sm.schoolName)")
        }
    }


}


