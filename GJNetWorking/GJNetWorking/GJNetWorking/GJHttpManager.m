//
//  GJHttpManager.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJHttpManager.h"
#import "AFNetworking.h"
#import "GJNetworkingConfig.h"

@interface GJHttpManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation GJHttpManager

+ (GJHttpManager *)sharedManager{
    static GJHttpManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GJHttpManager new];
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
    
    [self requestWithUrl:avalidUrl
                  method:method
              parameters:parameters];
    
}

- (void)requestWithUrl:(NSString *)url
                method:(GJRequestMethod)method
            parameters:(NSDictionary *)parameters{
    
    switch (method) {
        case GJRequestGet:
        {
            [self.manager GET:url
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
                      }];
        }
            break;
        case GJRequestPOST:
        {
            [self.manager POST:url
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
        }
            break;
        default:
            break;
    }
    
    
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
