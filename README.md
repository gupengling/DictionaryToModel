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
"class":["classId":110,"className":"12年级","infoTest":["infoId":25,"infoName":"花花"]],
"school":[["schoolId":10000,
"schoolName":"牛逼小学"],
["schoolId":10001,
"schoolName":"牛逼大学"]],
] as [String : AnyObject]
let teacher:TeacherModel = TeacherModel.objectWithKeyValues(keyValues: dict) as! TeacherModel


print("age = \(teacher.age) "+"name = \(teacher.name) "+"sex = \(teacher.sex) "+"coding = \(teacher.coding) "+"classId = \(teacher.classModel.classId) "+"className = \(teacher.classModel.className)"+"infoId = \(teacher.classModel.infoTestModel.infoId) "+"infoName=\(teacher.classModel.infoTestModel.infoName) ")
```

# HttpRequest

## OC版本

* 主要文件 **BaseRequest** ，**BaseResponse** 和 **HttpServiceEngine**

>* 使用方法

```
//创建一个Request对象，继承BaseRequest，实现里面必需重写的方法

@interface UserInfoRequest:BaseRequest
@property (nonatomic, strong) NSDictionary *requestParm;
@end

@implementation UserInfoRequest
- (NSString *)url {
NSString *host = [self hostUrl];
return [NSString stringWithFormat:@"%@/method",host];
}
- (NSDictionary *)packageParams {
return _requestParm;
//    NSDictionary *paramDic = @{@"name"  : @"yanzhenjie",
//                               @"pwd" : @"123" };
//    return paramDic;
}
//- (Class)responseDataClass {
//    return [UserInfoResponceData class];
//}
- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic {
return [UserInfoResponceData gpl_initWithDictionary:dataDic];
}
```

```
//根据requestParm 请求
UserInfoRequest *request = [[UserInfoRequest alloc] initWithSuccessCallBack:^(BaseRequest *request) {
UserInfoResponceData *data = (UserInfoResponceData *)request.response.data;
NSLog(@"code = %zd name = %@",request.response.error,data.blog);
} failCallBack:^(BaseRequest *request) {
NSLog(@"code = %zd message = %@",request.response.error,request.response.errorMessage);
}];
request.requestParm = @{@"name":@"yanzhenjie",
@"pwd":@"123"};
[[HttpServiceEngine sharedInstance] asyncGetRequest:request];
```


## Swift 4.0 版本

* 主要文件 **BaseRequest** ，**BaseResponseData** 和 **HttpServiceEngine**

>* 使用方法

```
//写一个Request对象继承BaseRequest，实现里面必需重写的方法
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
```

```
//根据requestParm 请求
let req: UserInfoRequest = UserInfoRequest()
req.initWithBlock(success: { (req) in
let resData:UserInfoResponceData = req.resopnse.data as! UserInfoResponceData
print("code = \(req.resopnse.error),token =\(resData.blog)")
let count:Int = resData.projectListCell.count
for i in 0..<count {
let cell:ProjectListCell = resData.projectListCell[i]
print("\ncomment = \(cell.comment) \nid = \(cell.projectId) \nname = \(cell.name) \nurl = \(cell.url)\n")
}
}) { (req) in
print("错误\(req.resopnse.error)")
}
req.requestParm = ["name":"yanzhenjie" as AnyObject,"pwd":"123" as AnyObject]
HttpServiceEngine.shareInstance.asyncGetRequest(req: req)
```

# 其他
欢迎沟通 QQ：574998838

未完待续

