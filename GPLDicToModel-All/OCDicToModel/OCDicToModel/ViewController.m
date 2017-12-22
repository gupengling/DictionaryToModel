//
//  ViewController.m
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import "HttpServiceEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testDic];
    [self testArr];
    
    UserInfoRequest *request = [[UserInfoRequest alloc] initWithSuccessCallBack:^(BaseRequest *request) {
        UserInfoResponceData *data = (UserInfoResponceData *)request.response.data;
        NSLog(@"code = %zd name = %@",request.response.error,data.blog);
    } failCallBack:^(BaseRequest *request) {
        NSLog(@"code = %zd message = %@",request.response.error,request.response.errorMessage);
    }];
    request.requestParm = @{@"name":@"yanzhenjie",
                            @"pwd":@"123"};
    [[HttpServiceEngine sharedInstance] asyncGetRequest:request];
}

- (void)testDic {
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
    NSLog(@"model-----id:%@, name:%@, phone:%@,  age:%@, userId:%@, userName:%@", model._id, model.name, model.phone, @(model.age), model.user.userId, model.user.userName);
    [model.arrUsers enumerateObjectsUsingBlock:^(UserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"arrUser----userId:%@", obj.userId);
    }];

}
- (void)testArr {
    NSArray *arrTest = @[@{@"id":@"121",
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
                           @"arrUsers":@[@{@"userId":@"3",@"userName":@"小花"},@{@"userId":@"4",@"userName":@"小张"},@{@"userId":@"5"}]},
                         @{@"id":@"122",
                           @"name":@"李四",
                           @"phone":@"110",
                           @"age":@10,
                           @"user":@{@"userId":@"2",@"userName":@"小强"},
                           @"userget":@[@"nimen",@"wode"],
                           @"userinfo":@{@"name":@"xiao强",
                                         @"sex":@true,
                                         @"classes":@[@"大学",@"小学"],
                                         @"school":@[@{@"schoolid":@"1001",@"schoolname":@"交通"},@{@"schoolid":@"1002",@"schoolname":@"复旦"}]
                                         },
                           @"arrUsers":@[@{@"userId":@"3",@"userName":@"小花"},@{@"userId":@"4",@"userName":@"小张"},@{@"userId":@"5"}]}
                         ];

    NSArray *arr = (NSArray *)[TestModel gpl_initWithArray:arrTest];
    for (TestModel *model in arr) {
        NSLog(@"model-----id:%@, name:%@, phone:%@,  age:%@, userId:%@, userName:%@", model._id, model.name, model.phone, @(model.age), model.user.userId, model.user.userName);
        [model.arrUsers enumerateObjectsUsingBlock:^(UserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"arrUser----userId:%@", obj.userId);
        }];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
