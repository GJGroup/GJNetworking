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

- (void)startRequest:(id<GJRequestProtocol>)request{
        
    NSString *baseUrl = nil;
    if ([request respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [request baseUrl];
    }
    
    if (!baseUrl.length) {
        baseUrl = [GJNetworkingConfig defaultBaseUrl];
    }
    NSParameterAssert(baseUrl);
    
    NSString *path = [request path];
    NSParameterAssert(path);
    
    GJRequestMethod method = [request method];

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
                  method:method
              parameters:parameters
                 request:request];
}

- (void)requestWithUrl:(NSString *)url
                method:(GJRequestMethod)method
            parameters:(NSDictionary *)parameters
               request:(id<GJRequestProtocol>)request{
    
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
                                       }];
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
                             request:(id<GJRequestProtocol>)request{
    
    BOOL success = operation.error ? NO : YES;
    id responseObject = operation.responseObject;
    
    //retry
    if (!success && [request retryTimes] > [request currentRetryTimes]) {
        [request retry];
        return;
    }
    
    //call back
    id<GJRequestProtocol> strongRequest = request;
    if (success && request.successBlock) {
        strongRequest.successBlock(responseObject, nil, nil);
    }
    
    if (!success && request.failedBlock) {
        strongRequest.failedBlock(responseObject, nil, operation.error);
    }
    
    strongRequest.successBlock = nil;
    strongRequest.failedBlock = nil;
    
}

- (void)cancelRequest:(id<GJRequestProtocol>)request{
    if (request.task) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)request.task;
        if (operation && !operation.isCancelled) {
            [operation cancel];
        }
    }
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
