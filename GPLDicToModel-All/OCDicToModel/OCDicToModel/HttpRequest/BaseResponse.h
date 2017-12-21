//
//  BaseResponse.h
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GPLDicToModel.h"

@interface BaseResponseData:NSObject

@end


@interface ProjectListCell : NSObject
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@end
@interface UserInfoResponceData : BaseResponseData

@property (nonatomic, copy) NSString *blog;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *arrProjectList;

@end


/////////////////////////////////////////////////////
@interface BaseResponse : NSObject
// 对应json中返回的字段
@property (nonatomic, assign) NSInteger error;
@property (nonatomic, copy) NSString *errorInfo;
@property (nonatomic, strong) BaseResponseData *data;

- (BOOL)success;
- (NSString *)message;
@end
