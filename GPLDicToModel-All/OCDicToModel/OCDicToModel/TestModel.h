//
//  TestModel.h
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GPLDicToModel.h"

@class UserModel;
@class UserInfoModel;

@interface TestModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *userget;
@property (nonatomic, strong) NSArray *arrUsers;
@property (nonatomic, strong) UserInfoModel *userinfo;
@end


@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end

@interface SchoolInfoModel :NSObject
@property (nonatomic, assign) NSInteger schoolid;
@property (nonatomic, copy) NSString *schoolname;
@end
@interface UserInfoModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSArray *school;
@end
