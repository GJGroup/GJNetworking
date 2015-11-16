//
//  GJHTTPManager.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJHTTPManager.h"
#import "AFNetworking.h"
#import "GJNetworkingConfig.h"

@interface GJHTTPManager ()<GJRequestDelegate>

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
    
    request.delegate = self;
    
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
    
    [self requestWithUrl:avalidUrl
                  method:method
              parameters:parameters
                 request:request];
    
}

- (void)requestWithUrl:(NSString *)url
                method:(GJRequestMethod)method
            parameters:(NSDictionary *)parameters
               request:(id<GJRequestProtocol>)request{
    
    switch (method) {
        case GJRequestGET:
        {
            [self.manager GET:url
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
            [self.manager POST:url
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
    
}

- (void)requestFinishedWithOperation:(AFHTTPRequestOperation*)operation
                             request:(id<GJRequestProtocol>)request{
    
    BOOL success = operation.error ? NO : YES;

    if (success) {
        if (request.successBlock) {
            request.successBlock(operation.responseObject, nil);
        }
    }
    else{
        if (request.failedBlock) {
            request.failedBlock(nil, operation.error);
        }
    }
    
}

- (void)cancelRequest:(id<GJRequestProtocol>)request{
    
}


- (NSString *)avalidUrlWithBaseUrl:(NSString *)base
                              path:(NSString *)path{
    
    NSMutableString *avalidUrl = [NSMutableString stringWithString:base];
    
    NSAssert([avalidUrl hasPrefix:@"http"], @"request is not a http or https type!");
    
    BOOL urlSlash = [avalidUrl hasSuffix:@"/"];
    
    BOOL pathSlash = [path hasPrefix:@"/"];
    
    if (urlSlash && pathSlash) {
        [avalidUrl deleteCharactersInRange:NSMakeRange(avalidUrl.length - 1, 1)];
    }
    else if (!urlSlash && !pathSlash){
        [avalidUrl appendString:@"/"];
    }
    
    [avalidUrl appendString:path];
    
    return avalidUrl;
    
}

@end
