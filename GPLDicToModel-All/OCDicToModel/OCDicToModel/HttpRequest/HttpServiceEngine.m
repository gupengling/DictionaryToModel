//
//  HttpServiceEngine.m
//  OCDicToModel
//
//  Created by GPL on 2017/12/21.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import "HttpServiceEngine.h"

typedef NS_ENUM(NSInteger, RequestKindStyle) {
    RequestKindStylePost = 0,
    RequestKindStylePostJson,
    RequestKindStyleGet,
};

static NSInteger const HttpRequestTimeOut = 30;

static HttpServiceEngine *serviceEngine = nil;

@interface HttpServiceEngine()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation HttpServiceEngine
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceEngine = [[HttpServiceEngine alloc] init];
    });
    return serviceEngine;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sharedSession];
    }
    return self;
}

/**
 GET请求方式
 
 @param request 请求体
 */
- (void)asyncGetRequest:(BaseRequest *)request {
    [self asyncRequest:request requestStyle:RequestKindStyleGet];
}

/**
 POST JSON 请求方式
 
 @param request 请求体
 */
- (void)asyncPostJsonRequest:(BaseRequest *)request {
    [self asyncRequest:request requestStyle:RequestKindStylePostJson];
}
//通用请求体
- (void)asyncRequest:(BaseRequest *)request requestStyle:(RequestKindStyle)style {
    if (request) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSString *url = [request url];
            NSLog(@"reqest url = %@", url);
            if (url == nil || url.length < 1) {
                NSLog(@"[%@]请求URL出错了", [request class]);
                return ;
            }
            NSMutableURLRequest *urlRequest;
            if (style == RequestKindStylePost) {

                NSData *data = [request toPostJsonData];
                NSURL *URL = [NSURL URLWithString:url];
                urlRequest = [NSMutableURLRequest requestWithURL:URL];

                [urlRequest setTimeoutInterval:HttpRequestTimeOut];
                if (data) {
                    [urlRequest setValue:[NSString stringWithFormat:@"%ld",(long)[data length]] forHTTPHeaderField:@"Content-Length"];
                    [urlRequest setHTTPMethod:@"POST"];
                    [urlRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                    [urlRequest setHTTPBody:data];
                }
                
            }else if (style == RequestKindStyleGet){
                
                NSURL *URL = [NSURL URLWithString:[request toGetUrlString]];
                urlRequest = [NSMutableURLRequest requestWithURL:URL];
                
                [urlRequest setTimeoutInterval:HttpRequestTimeOut];
                
                [urlRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
                [urlRequest setHTTPShouldHandleCookies:FALSE];
                [urlRequest setHTTPMethod:@"GET"];

            }
            
            NSURLSessionDataTask *task = [_session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error != nil) {
                    if (request.failBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            request.failBlock(request);
                        });
                    }else {
                        NSLog(@"请求失败[%@]",error.localizedFailureReason);
                    }
                }else {
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"[%@] 请求的返回原数据串 :\n================================\n %@ \n================================" , [request class], responseString);
                    NSObject *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    [request parseResponse:jsonObj];
                }
            }];
            [task resume];
        });
    }
}
@end
