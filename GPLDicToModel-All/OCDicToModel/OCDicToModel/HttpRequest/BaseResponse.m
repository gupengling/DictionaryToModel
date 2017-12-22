//
//  BaseResponse.m
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "BaseResponse.h"
@implementation BaseResponseData


@end


@implementation ProjectListCell
+(NSDictionary *)gpl_propertyReplacedKeyWithValue
{
    return @{@"projectId":@"id"};
}

@end

@implementation UserInfoResponceData
+ (NSDictionary *)gpl_propertyReplacedKeyWithValue {
    return @{@"arrProjectList":@"projectList"};
}
+(NSDictionary *)gpl_objectClassKeyInArray
{
    return @{@"arrProjectList":@"ProjectListCell"};
}


@end


/////////////////////////////////////////////////////
@implementation BaseResponse

- (instancetype)init
{
    if (self = [super init]) {
        // 默认成功
        _error = 1;
        _message = @"";
    }
    return self;
}

- (BOOL)success
{
    return _error == 1;
}
- (NSString *)errorMessage
{
    return _message;
}

@end
