//
//  GJNetworkingConfig.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GJModelMakerDelegate.h"

@interface GJNetworkingConfig : NSObject 

+ (void)setDefaultBaseUrl:(NSString *)baseUrl
   acceptableContentTypes:(NSSet *)contentTypes
 allowInvalidCertificates:(BOOL)allowInvalidCer
      validatesDomainName:(BOOL)validDomain
        maxOperationCount:(int)operationCount
               modelMaker:(id<GJModelMakerDelegate>)maker
            modelKeysPath:(NSArray *)keysPath;

+ (NSString *)defaultBaseUrl;

+ (NSSet *)acceptableContentTypes;

+ (BOOL)allowInvalidCertificates;

+ (BOOL)validatesDomainName;

+ (int)maxConcurrentOperationCount;

+ (id<GJModelMakerDelegate>)modelMaker;

+ (NSArray *)modelKeysPath;

@end
