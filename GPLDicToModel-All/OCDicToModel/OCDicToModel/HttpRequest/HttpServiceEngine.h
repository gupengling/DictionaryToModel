//
//  HttpServiceEngine.h
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface HttpServiceEngine : NSObject
+ (instancetype)sharedInstance;

/**
 GET请求方式

 @param request 请求体
 */
- (void)asyncGetRequest:(BaseRequest *)request;

/**
 POST JSON 请求方式
 
 @param request 请求体
 */
- (void)asyncPostJsonRequest:(BaseRequest *)request;

@end
