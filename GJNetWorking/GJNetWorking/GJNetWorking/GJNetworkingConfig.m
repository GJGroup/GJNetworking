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

@implementation GJNetworkingConfig

+ (void)setDefaultBaseUrl:(NSString *)base
   acceptableContentTypes:(NSSet *)contentTypes
 allowInvalidCertificates:(BOOL)allowInvalidCer
      validatesDomainName:(BOOL)validDomain
        maxOperationCount:(int)operationCount{
    
    baseUrl = base ? [base copy] : nil;
    acceptableContentTypes = contentTypes ? contentTypes : nil;
    allowInvalidCertificates = allowInvalidCer;
    validatesDomainName = validDomain;
    maxConcurrentOperationCount = operationCount ? operationCount : 4;
    
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

@end
