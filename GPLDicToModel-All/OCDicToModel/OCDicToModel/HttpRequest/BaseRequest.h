//
//  BaseRequest.h
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"

@class BaseRequest;

typedef void (^RequestBlock)(BaseRequest *request);
@interface BaseRequest : NSObject
{
    @protected
    
    @private
    
    @public
    
}
@property (nonatomic, strong) BaseResponse *response;
@property (nonatomic, copy) RequestBlock succBlock;
@property (nonatomic, copy) RequestBlock failBlock;

/**
 初始化请求框架
 
 @param succCallBack 成功返回结果
 @return self
 */
- (instancetype)initWithSuccessCallBack:(RequestBlock)succCallBack;
- (instancetype)initWithSuccessCallBack:(RequestBlock)succCallBack failCallBack:(RequestBlock)failCallBack;

/** 基础设置 */
- (NSString *)hostUrl;
- (NSString *)url;
- (NSDictionary *)packageParams;
// 拼装成Json请求包
- (NSData *)toPostJsonData;
//拼装geturl
- (NSMutableString *)toGetUrlString;
// 收到响应后作解析响应处理
- (void)parseResponse:(NSObject *)respJsonObject;
- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic;

// 配置_response对应的类
- (Class)responseClass;
//- (Class)responseDataClass;

@end

//////////////////////////////////////////////////////////////////////
@interface UserInfoRequest:BaseRequest
@property (nonatomic, strong) NSDictionary *requestParm;
@end
