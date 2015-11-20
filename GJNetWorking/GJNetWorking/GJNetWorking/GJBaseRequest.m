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
    
    __weak typeof(self) weakSelf = self;
    
    _successBlock = ^(id responseJson, id status , NSError *error){
        
        //make model
        BOOL success = error ? NO : YES;
        id responseStatus;
        id responseObject = responseJson;
        
        //if request success and request implement modelClass,
        //when request or default modelMaker implement the delegate ,
        //the response object will be make to model or model list.
        if (success && [weakSelf respondsToSelector:@selector(modelClass)]){
            id<GJModelMakerDelegate> defaultModelMaker = [GJNetworkingConfig modelMaker];
            id<GJModelMakerDelegate> modelMaker = nil;
            if (self && [weakSelf respondsToSelector:@selector(makeModelWithJSON:class:status:)]) {
                modelMaker = weakSelf;
            }
            else if (defaultModelMaker && [defaultModelMaker respondsToSelector:@selector(makeModelWithJSON:class:status:)]){
                modelMaker = defaultModelMaker;
            }
            
            if (modelMaker) {
                responseObject = [modelMaker makeModelWithJSON:responseObject
                                                         class:[weakSelf modelClass]
                                                        status:&responseStatus];
            }
            
        }

        !successBlock ? : successBlock(responseJson , responseStatus, error);
        
        [weakSelf setSuccessBlock:nil];
        
    };
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
