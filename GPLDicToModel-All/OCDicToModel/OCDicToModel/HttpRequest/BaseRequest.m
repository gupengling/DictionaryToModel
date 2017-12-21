//
//  BaseRequest.m
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest
- (void)dealloc
{
    NSLog(@"[%@] release成功>>>>>>>>>", NSStringFromClass([self class]));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithSuccessCallBack:(RequestBlock)succCallBack {
    self = [self init];
    if (self) {
        self.succBlock = succCallBack;
    }
    return self;
}
- (instancetype)initWithSuccessCallBack:(RequestBlock)succCallBack failCallBack:(RequestBlock)failCallBack {
    self = [self initWithSuccessCallBack:succCallBack];
    if (self) {
        self.failBlock = failCallBack;
    }
    return self;
}
/** 基础设置 */
- (NSString *)hostUrl {
    return @"http://api.nohttp.net";
}
- (NSString *)url {
    NSAssert(NO, @"需要重写 - url");
    return nil;
}
- (NSDictionary *)packageParams {
    NSAssert(NO, @"需要重写 - packageParams");
    return nil;
}
// 拼装成Json请求包
- (NSData *)toPostJsonData {
    NSDictionary *dic = [self packageParams];
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if(error) {
            NSLog(@"[%@] Post Json Error: %@", [self class], dic);
        }
        else {
            NSLog(@"[%@] Post Json : %@", [self class], dic);
        }
        return data;
    }
    else {
        NSLog(@"[%@] Post Json is not valid: %@", [self class], dic);
    }
    return nil;
}
//拼装geturl
- (NSMutableString *)toGetUrlString{
    NSMutableString *urlM = [NSMutableString stringWithFormat:@"%@?",self.url];
    
    NSDictionary *dic = [self packageParams];
    for (NSString *key in [dic allKeys]) {
        if ([dic valueForKey:key]) {
            [urlM appendFormat:@"%@=%@&",key,[dic valueForKey:key]];
        }
    }
    return urlM;
}
// 收到响应后作解析响应处理
- (void)parseResponse:(NSObject *)respJsonObject {
    if (respJsonObject) {
        NSLog(@"[%@]开始解析响应<<<<<<<<<<", self);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if (_succBlock) {
                if ([respJsonObject isKindOfClass:[NSDictionary class]]) {
                    [self parseDictionaryResponse:(NSDictionary *)respJsonObject];
               // }else if ([respJsonObject isKindOfClass:[NSArray class]]) {
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msg = [NSString stringWithFormat:@"返回数据格式有误 %@",respJsonObject];
                        NSLog(@"msg %@",msg);
                        if (_failBlock) {
                            _failBlock(self);
                        }
                        NSLog(@"[%@]解析响应完成<<<<<<", self);
                    });
                    return ;

                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([_response success]) {
                        _succBlock(self);
                    }else {
                        NSString *msg = [NSString stringWithFormat:@"返回的数据有业务错误 %@",[_response message]];
                        NSLog(@"msg %@",msg);
                        // 返回的数据有业务错误
                        if (_failBlock) {
                            _failBlock(self);
                        }
                    }
                    NSLog(@"[%@]解析响应完成<<<<<<", self);
                });
                
            }
        });
    }else {
        NSLog(@"接受到的数据 失败 --> %@",respJsonObject);
        NSString *msg = [NSString stringWithFormat:@"返回数据为空 %@",[self class]];
        NSLog(@"msg = %@",msg);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 说明返回内容有问题
            if (_failBlock) {
                _response.error = -1;
                _response.errorInfo = @"返回数据非Json格式";
                _failBlock(self);
            }
            NSLog(@"[%@]解析响应完成<<<<<<", self);
        });

    }
}

- (Class)responseClass {
    return [BaseResponse class];
}
//- (Class)responseDataClass {
//    NSAssert(NO, @"需要重写 - responseDataClass");
//    return [BaseResponseData class];
//}
// 解析返回的字典结构json
- (void)parseDictionaryResponse:(NSDictionary *)bodyDic
{
    _response = [[[self responseClass] alloc] init];
    _response.error = [bodyDic[@"error"] integerValue];
    _response.errorInfo = bodyDic[@"errorInfo"];
    NSDictionary *data = bodyDic[@"data"];
    
    NSLog(@"[%@]开始转换模型对象<<<<<<<<<<<<<\n====================\ndata=%@\n====================",self,data.description);
    _response.data = [self parseResponseData:data];
}
- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    NSAssert(NO, @"需要重写 - parseResponseData:");
    return nil;//[NSObject parse:[self responseDataClass] dictionary:dataDic];
}

@end


//////////////////////////////////////////////////////////////////////
@implementation UserInfoRequest
- (NSString *)url {
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@/method",host];//?name=yanzhenjie&pwd=123
}
- (NSDictionary *)packageParams {
    return _requestParm;
//    NSDictionary *paramDic = @{@"name"  : @"yanzhenjie",
//                               @"pwd" : @"123" };
//    return paramDic;
}
//- (Class)responseDataClass {
//    return [LoginResponceData class];
//}
- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic {
    return [UserInfoResponceData gpl_initWithDictionary:dataDic];
}
@end

