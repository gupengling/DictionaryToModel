//
//  ViewController.m
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
