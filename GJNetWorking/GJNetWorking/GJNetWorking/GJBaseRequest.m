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
}

@end

@implementation GJBaseRequest

//default method is 'GET'
- (GJRequestMethod)method{
    return GJRequestGET;
}

- (void)start{
    [[GJHTTPManager sharedManager] startRequest:self];
}

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed
{
    self.successBlock = success;
    self.failedBlock = failed;
    [self start];
}

- (void)cancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRequest:)]){
        [self.delegate cancelRequest:self];
    }
}

#pragma mark- property - block

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


@end
