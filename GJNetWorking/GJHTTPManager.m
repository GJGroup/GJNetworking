//
//  GJHTTPManager.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJHTTPManager.h"
#import "AFNetworking.h"


@interface GJHTTPManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation GJHTTPManager

+ (GJHTTPManager *)sharedManager{
    static GJHTTPManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GJHTTPManager new];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [GJNetworkingConfig acceptableContentTypes];
    self.manager.securityPolicy.allowInvalidCertificates = [GJNetworkingConfig allowInvalidCertificates];
    self.manager.securityPolicy.validatesDomainName = [GJNetworkingConfig validatesDomainName];
    self.manager.operationQueue.maxConcurrentOperationCount = [GJNetworkingConfig maxConcurrentOperationCount];
    
    return self;
}

- (void)startRequest:(GJBaseRequest *)request {
    
    //clear requestSerializer
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    __block NSString *baseUrl = nil;
    
    if ([request respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [request baseUrl];
    }
    
    if (!baseUrl.length) {
        baseUrl = [GJNetworkingConfig defaultBaseUrl];
    }
    
    if ([request respondsToSelector:@selector(dNSWithBaseUrl:dNSBlock:)]) {
        [request dNSWithBaseUrl:baseUrl
                       dNSBlock:^(BOOL usedDNS, NSString *domain, NSString *newBaseUrl) {
            if (usedDNS) {
                baseUrl = [newBaseUrl copy];
                [_manager.requestSerializer setValue:domain forKey:@"host"];
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
    
    AFHTTPRequestOperation *startOperation = nil;
    
    switch (method) {
        case GJRequestGET:
        {
            startOperation = [self.manager GET:url
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [self requestFinishedWithOperation:operation request:request];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self requestFinishedWithOperation:operation request:request];
;                                       }];
        }
            break;
        case GJRequestPOST:
        {
            startOperation = [self.manager POST:url
                                     parameters:parameters
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            [self requestFinishedWithOperation:operation request:request];
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [self requestFinishedWithOperation:operation request:request];
                                        }];
        }
            break;
        case GJRequestDELET:
        {
            startOperation = [self.manager DELETE:url
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [self requestFinishedWithOperation:operation request:request];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [self requestFinishedWithOperation:operation request:request];
                                          }];
        }
            break;
        case GJRequestHEAD:
        {
            startOperation = [self.manager HEAD:url
                                     parameters:parameters
                                        success:^(AFHTTPRequestOperation *operation) {
                                            [self requestFinishedWithOperation:operation request:request];
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [self requestFinishedWithOperation:operation request:request];
                                        }];
                              
        }
            break;
        case GJRequestPUT:
        {
            startOperation = [self.manager PUT:url
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [self requestFinishedWithOperation:operation request:request];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self requestFinishedWithOperation:operation request:request];
                                       }];
        }
            break;
        case GJRequestPATCH:
        {
            startOperation = [self.manager PATCH:url
                                      parameters:parameters
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [self requestFinishedWithOperation:operation request:request];
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [self requestFinishedWithOperation:operation request:request];
                                         }];
        }
            break;
        default:
            break;
    }
    
    request.task = startOperation;
    
}

- (void)requestFinishedWithOperation:(AFHTTPRequestOperation*)operation
                             request:(GJBaseRequest *)request {
    
    GJBaseRequest *strongRequest = request;
    BOOL success = operation.error ? NO : YES;
    
    if ([strongRequest respondsToSelector:@selector(shouldRetryWithResponseObject:error:)]) {
        BOOL shouldRetry = [strongRequest shouldRetryWithResponseObject:operation.responseObject
                                                                  error:operation.error];
        
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
    
    //没有重试则请求完成
    [strongRequest requestTerminate];
}

- (BOOL)cancelRequest:(GJBaseRequest *)request{
    if (request.task) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)request.task;
        if (operation && !operation.isCancelled) {
            [operation cancel];
            return YES;
        }
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
