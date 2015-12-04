//
//  GJNetworkingConfig.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJNetworkingConfig.h"

static NSString *baseUrl;
static NSSet *acceptableContentTypes;
static BOOL allowInvalidCertificates = NO;
static BOOL validatesDomainName = NO;
static int maxConcurrentOperationCount = 4;
static id<GJModelMakerDelegate> modelMaker;
static NSTimeInterval timeOutInterval = 60;

@implementation GJNetworkingConfig

+ (void)setDefaultBaseUrl:(NSString *)base
   acceptableContentTypes:(NSSet *)contentTypes
 allowInvalidCertificates:(BOOL)allowInvalidCer
      validatesDomainName:(BOOL)validDomain
        maxOperationCount:(int)operationCount
          timeOutInterval:(NSTimeInterval)timeOut
               modelMaker:(id<GJModelMakerDelegate>)maker{
    
    baseUrl = base ? [base copy] : nil;
    acceptableContentTypes = contentTypes ? contentTypes : nil;
    allowInvalidCertificates = allowInvalidCer;
    validatesDomainName = validDomain;
    maxConcurrentOperationCount = operationCount ? operationCount : 4;
    if (!modelMaker && maker) {
        modelMaker = maker;
    }
    timeOutInterval = timeOut ? timeOut : 60;
}

+ (NSString *)defaultBaseUrl{
    return baseUrl;
}

+ (NSSet *)acceptableContentTypes{
    return acceptableContentTypes;
}

+ (BOOL)allowInvalidCertificates{
    return allowInvalidCertificates;
}

+ (BOOL)validatesDomainName{
    return validatesDomainName;
}

+ (int)maxConcurrentOperationCount{
    return maxConcurrentOperationCount;
}

+ (id<GJModelMakerDelegate>)modelMaker{
    return modelMaker;
}

+ (NSTimeInterval)timeOutInterval{
    return timeOutInterval;
}

@end


static NSString *gj_cacheDirectory = @"GJAPICacheDirectory";

@implementation GJNetworkingConfig (GJAPICache)

+ (void)setCacheDirectory:(NSString *)dir {
    gj_cacheDirectory = dir;
}

+ (NSString *)getCacheDirectory {
    return gj_cacheDirectory;
}

@end
