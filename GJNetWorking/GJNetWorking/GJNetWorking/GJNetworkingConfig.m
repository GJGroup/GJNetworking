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
static NSArray *modelKeysPath;

@implementation GJNetworkingConfig

+ (void)setDefaultBaseUrl:(NSString *)base
   acceptableContentTypes:(NSSet *)contentTypes
 allowInvalidCertificates:(BOOL)allowInvalidCer
      validatesDomainName:(BOOL)validDomain
        maxOperationCount:(int)operationCount
               modelMaker:(id<GJModelMakerDelegate>)maker
            modelKeysPath:(NSArray *)keysPath{
    
    baseUrl = base ? [base copy] : nil;
    acceptableContentTypes = contentTypes ? contentTypes : nil;
    allowInvalidCertificates = allowInvalidCer;
    validatesDomainName = validDomain;
    maxConcurrentOperationCount = operationCount ? operationCount : 4;
    if (!modelMaker && maker) {
        modelMaker = maker;
    }
    modelKeysPath = keysPath.count ? [keysPath copy] : nil;
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

+ (NSArray *)modelKeysPath{
    return modelKeysPath;
}

@end
