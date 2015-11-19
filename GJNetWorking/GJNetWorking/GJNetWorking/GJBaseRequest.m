//
//  GJBaseRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJBaseRequest.h"
#import "GJHTTPManager.h"

@interface GJBaseRequest ()
{
    GJRequestFinishedBlock _successBlock;
    GJRequestFinishedBlock _failedBlock;
    __weak id _delegate;
    __weak id _task;
    NSUInteger _currentRetryTimes;
}

@end

@implementation GJBaseRequest

//default method is 'GET'
- (GJRequestMethod)method{
    return GJRequestGET;
}

- (void)start{
    if (_delegate && [_delegate respondsToSelector:@selector(requestWillStart:)]) {
        [_delegate requestWillStart:self];
    }
    [[GJHTTPManager sharedManager] startRequest:self];
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidStart:)]) {
        [_delegate requestDidStart:self];
    }
}

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed
{
    self.successBlock = success;
    self.failedBlock = failed;
    [self start];
}

- (void)cancel{
    [[GJHTTPManager sharedManager] cancelRequest:self];
}

- (void)retry{
    _currentRetryTimes ++;
    [self start];
}

- (NSUInteger)retryTimes{
    return 0;
}

#pragma mark- property impletemention

- (void)setDelegate:(id<GJRequestDelegate>)delegate{
    _delegate = delegate;
}

- (id<GJRequestDelegate>)delegate{
    return _delegate;
}

- (void)setSuccessBlock:(GJRequestFinishedBlock)successBlock{
    
    _successBlock = successBlock;
}

- (void)setFailedBlock:(GJRequestFinishedBlock)failedBlock{
    _failedBlock = failedBlock;
}

- (GJRequestFinishedBlock)successBlock{
    return _successBlock;
}

- (GJRequestFinishedBlock)failedBlock{
    return _failedBlock;
}

- (void)setTask:(id)task{
    _task = task;
}

- (id)task{
    return _task;
}

- (NSUInteger)currentRetryTimes{
    return _currentRetryTimes;
}



@end
