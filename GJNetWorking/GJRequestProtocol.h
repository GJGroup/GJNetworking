//
//  GJRequestProtocol.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJBaseRequest;

@protocol GJRequestDelegate <NSObject>

- (void)requestWillStart:(GJBaseRequest *)request;
- (void)requestDidStart:(GJBaseRequest *)request;

- (void)requestWillStop:(GJBaseRequest *)request;
- (void)requestDidStop:(GJBaseRequest *)request;

@end

