//
//  GJHTTPManager.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJHTTPManager.h"
#import "AFNetworking.h"

@interface GJBaseRequest ()

@property (nonatomic, readwrite, strong) NSError *error;

@property (nonatomic, readwrite, strong) id responseObject;
@property (nonatomic, readwrite, strong) id responseJson;

@end

@interface GJHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPSessionManager *imageManager;

@end

@implementation GJHTTPManager

#pragma mark- initalizer
+ (GJHTTPManager *)sharedManager{
    static GJHTTPManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GJHTTPManager new];
    });
    return instance;
}

- (AFHTTPSessionManager *)createManagerWithType:(GJResponseType)type {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = [GJNetworkingConfig allowInvalidCertificates];
    manager.securityPolicy.validatesDomainName = [GJNetworkingConfig validatesDomainName];

    if (type == GJResponseTypeImage) {
        manager.responseSerializer = [AFImageResponseSerializer serializer];
    }
    else {
        manager.responseSerializer.acceptableContentTypes = [GJNetworkingConfig acceptableContentTypes];
    }
    
    return manager;
}

- (AFHTTPSessionManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [self createManagerWithType:GJResponseTypeImage];
    }
    return _imageManager;
}

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    self.manager = [self createManagerWithType:GJResponseTypeDefault];
    return self;
}

- (void)startRequest:(GJBaseRequest *)request {
    
    //clear requestSerializer header host
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"host"];
    
    __block NSString *baseUrl = nil;
    
    if ([request respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [request baseUrl];
    }
    
    if (!baseUrl.length) {
        baseUrl = [GJNetworkingConfig defaultBaseUrl];
    }
    
    //实现此方法，使用了dns，需要设置header host
    if ([request respondsToSelector:@selector(dNSWithBaseUrl:dNSBlock:)]) {
        [request dNSWithBaseUrl:baseUrl
                       dNSBlock:^(BOOL usedDNS, NSString *domain, NSString *newBaseUrl) {
            if (usedDNS) {
                baseUrl = [newBaseUrl copy];
                [_manager.requestSerializer setValue:domain forHTTPHeaderField:@"host"];
            }
        }];
    }
    
    NSString *path = [request path];
    
    NSParameterAssert(baseUrl);
    NSParameterAssert(path);
    
    NSString *avalidUrl = [self avalidUrlWithBaseUrl:baseUrl
                                                path:path];
    
    NSDictionary *parameters = nil;
    if ([request respondsToSelector:@selector(parameters)]) {
        parameters = [request parameters];
    }
    
    if ([request respondsToSelector:@selector(timeOutInterval)]) {
        self.manager.requestSerializer.timeoutInterval = [request timeOutInterval];
    }
    else{
        self.manager.requestSerializer.timeoutInterval = [GJNetworkingConfig timeOutInterval];
    }

    [self requestWithUrl:avalidUrl
                  method:[request method]
              parameters:parameters
                 request:request];
}

- (void)requestWithUrl:(NSString *)url
                method:(GJRequestMethod)method
            parameters:(NSDictionary *)parameters
               request:(GJBaseRequest *)request {
    
    NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *manager = request.responseType == GJResponseTypeImage ? self.imageManager : self.manager;
    
    switch (method) {
        case GJRequestGET:
        {
            task = [manager GET:url
                     parameters:parameters
                       progress:^(NSProgress * _Nonnull downloadProgress) {
                           
                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           [self requestFinishedWithOperation:task
                                                      request:request
                                               responseObject:responseObject
                                                        error:nil];
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [self requestFinishedWithOperation:task
                                                      request:request
                                               responseObject:nil
                                                        error:error];
                       }];
        }
            break;
        case GJRequestPOST:
        {
            task = [manager POST:url
                      parameters:parameters
                        progress:^(NSProgress * _Nonnull downloadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            [self requestFinishedWithOperation:task
                                                       request:request
                                                responseObject:responseObject
                                                         error:nil];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            [self requestFinishedWithOperation:task
                                                       request:request
                                                responseObject:nil
                                                         error:error];
                        }];
        }
            break;
        case GJRequestDELET:
        {
            task = [manager DELETE:url
                        parameters:parameters
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               [self requestFinishedWithOperation:task
                                                          request:request
                                                   responseObject:responseObject
                                                            error:nil];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               [self requestFinishedWithOperation:task
                                                          request:request
                                                   responseObject:nil
                                                            error:error];
                           }];
        }
            break;
        case GJRequestHEAD:
        {
            task = [manager HEAD:url
                      parameters:parameters
                         success:^(NSURLSessionDataTask * _Nonnull task) {
                             [self requestFinishedWithOperation:task
                                                        request:request
                                                 responseObject:nil
                                                          error:nil];
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [self requestFinishedWithOperation:task
                                                        request:request
                                                 responseObject:nil
                                                          error:error];
                         }];
        }
            break;
        case GJRequestPUT:
        {
            task = [manager PUT:url
                     parameters:parameters
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            [self requestFinishedWithOperation:task
                                                       request:request
                                                responseObject:responseObject
                                                         error:nil];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            [self requestFinishedWithOperation:task
                                                       request:request
                                                responseObject:nil
                                                         error:error];
                        }];
        }
            break;
        case GJRequestPATCH:
        {
            task = [manager PATCH:url
                       parameters:parameters
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              [self requestFinishedWithOperation:task
                                                         request:request
                                                  responseObject:responseObject
                                                           error:nil];
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              [self requestFinishedWithOperation:task
                                                         request:request
                                                  responseObject:nil
                                                           error:error];
                          }];
        }
            break;
        default:
            break;
    }
    
    request.task = task;
    
}

- (void)requestFinishedWithOperation:(NSURLSessionDataTask *)task
                             request:(GJBaseRequest *)request
                      responseObject:(id)responseObject
                               error:(NSError *)error {
    
    GJBaseRequest *strongRequest = request;

    BOOL success = request.error ? NO : YES;
    
    if ([strongRequest respondsToSelector:@selector(shouldRetryWithResponseObject:error:)]) {
        BOOL shouldRetry = [strongRequest shouldRetryWithResponseObject:responseObject
                                                                  error:error];
        
        if (shouldRetry) {
            [strongRequest start];
            return;
        }
    }
    
    //retry
    if (!success && [strongRequest retryTimes] > [strongRequest currentRetryTimes]) {
        [strongRequest retry];
        return;
    }
    
    request.error = error;
    request.responseObject = responseObject;
    request.responseJson = responseObject;
    //没有重试则请求完成
    [strongRequest requestTerminate];
}

- (BOOL)cancelRequest:(GJBaseRequest *)request{
    if (request.task && request.task.state == NSURLSessionTaskStateRunning) {
        [request.task cancel];
        return YES;
    }
    return NO;
}


- (NSString *)avalidUrlWithBaseUrl:(NSString *)base
                              path:(NSString *)path{
    
    NSString *baseUrlStr = [base stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pathStr = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    pathStr = [pathStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSMutableString *avalidUrl = [NSMutableString stringWithString:baseUrlStr];
    
    NSAssert([avalidUrl hasPrefix:@"http"], @"request is not a http or https type!");
    
    BOOL urlSlash = [avalidUrl hasSuffix:@"/"];
    
    BOOL pathSlash = [pathStr hasPrefix:@"/"];
    
    if (urlSlash && pathSlash) {
        [avalidUrl deleteCharactersInRange:NSMakeRange(avalidUrl.length - 1, 1)];
    }
    else if (!urlSlash && !pathSlash){
        [avalidUrl appendString:@"/"];
    }
    
    [avalidUrl appendString:pathStr];
    
    return avalidUrl;
    
}

@end
