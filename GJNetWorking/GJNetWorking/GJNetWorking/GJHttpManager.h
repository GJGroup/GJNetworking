//
//  GJHttpManager.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJRequestProtocol.h"

@interface GJHttpManager : NSObject

+ (GJHttpManager *)sharedManager;

- (void)startRequest:(id<GJRequestProtocol>)request;

@end
