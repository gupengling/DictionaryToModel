# DicToModel

* 字典转换模型 swift4.0 和 oc 版本

## OC版本

* 思维逻辑用运行时对对象进行属性映射

* 将两个扩展类导入工程中 **NSObject+GPLDicToModel.h** 和 **NSObject+GPLDicToModel.m**

> * 使用方法

```
NSDictionary *dicTest = @{@"id":@"121",
@"name":@"张三",
@"phone":@"110",
@"age":@10,
@"user":@{@"userId":@"2",@"userName":@"小明"},
@"userget":@[@"nimen",@"wode"],
@"userinfo":@{@"name":@"xiaoming",
@"sex":@true,
@"classes":@[@"大学",@"小学"],
@"school":@[@{@"schoolid":@"1001",@"schoolname":@"交通"},@{@"schoolid":@"1002",@"schoolname":@"复旦"}]
},
@"arrUsers":@[@{@"userId":@"3",@"userName":@"小花"},@{@"userId":@"4",@"userName":@"小张"},@{@"userId":@"5"}]};

TestModel *model = [TestModel gpl_initWithDictionary:dicTest];
```

## swift4.0 版本

* 思维逻辑用运行时对对象进行属性映射
* 将NSObject 扩展类导入工程中 **DicToModel.swift**

>* 使用方法

```
let dict = ["age":24,
"name":"阿花",
"sex":true,
"code":["英语","java","php","swift"],
"class":["classId":110,"className":"12年级"],
"school":[["schoolId":10000,
"schoolName":"牛逼小学"],
["schoolId":10001,
"schoolName":"牛逼大学"]],
] as [String : AnyObject]
let teacher:TeacherModel = TeacherModel.objectWithKeyValues(keyValues: dict) as! TeacherModel

print("age = \(teacher.age) "+"name = \(teacher.name) "+"sex = \(teacher.sex) "+"coding = \(teacher.coding) "+"classId = \(teacher.classModel.classId) "+"className = \(teacher.classModel.className)")
```

## 其他
未完待续
