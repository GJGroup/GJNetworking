//
//  GJHTTPManager.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

//  GJHTTPManager 

#import <Foundation/Foundation.h>
#import "GJRequestProtocol.h"
#import "GJNetworkingConfig.h"
#import "GJBaseRequest.h"

@interface GJHTTPManager : NSObject

+ (GJHTTPManager *)sharedManager;

- (void)startRequest:(GJBaseRequest *)request;

- (BOOL)cancelRequest:(GJBaseRequest *)request;

@end
