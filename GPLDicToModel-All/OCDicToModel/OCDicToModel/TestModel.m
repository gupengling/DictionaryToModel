//
//  TestModel.m
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
+(NSDictionary *)gpl_objectClassKeyInArray
{
    return @{@"arrUsers":@"UserModel"};
}
+(NSDictionary *)gpl_propertyReplacedKeyWithValue
{
    return @{@"_id":@"id"};
}

@end

@implementation UserModel


@end

@implementation SchoolInfoModel

@end
@implementation UserInfoModel
+ (NSDictionary *)gpl_objectClassKeyInArray
{
    return @{@"school":@"SchoolInfoModel"};
}

@end
