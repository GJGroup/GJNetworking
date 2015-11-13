//
//  GJRequestProtocol.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GJRequestMethod) {
    GJRequestGet,
    GJRequestPOST,
    GJRequestHEAD,
    GJRequestPUT,
    GJRequestPATCH,
    GJRequestDELET
};

@protocol GJRequestProtocol <NSObject>

@required

- (NSString *)path;

- (GJRequestMethod)method;


@optional

- (NSString *)baseUrl;

- (NSDictionary *)parameters;


- (void)start;


@end
