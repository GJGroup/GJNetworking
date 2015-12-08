//
//  GJRequestProtocol.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GJRequestMethod) {
    GJRequestGET,
    GJRequestPOST,
    GJRequestHEAD,
    GJRequestPUT,
    GJRequestPATCH,
    GJRequestDELET
};

typedef void (^GJRequestFinishedBlock)(id responseObject, id status , NSError *error);


@protocol GJRequestProtocol;


@protocol GJRequestDelegate <NSObject>

- (void)requestWillStart:(id<GJRequestProtocol>)request;
- (void)requestDidStart:(id<GJRequestProtocol>)request;

- (void)requestWillStop:(id<GJRequestProtocol>)request;
- (void)requestDidStop:(id<GJRequestProtocol>)request;

@end


@protocol GJRequestProtocol <NSObject>

@property (nonatomic, weak) id<GJRequestDelegate> delegate;

//the real task object, we use 'id' because we don't want ref specific object.
@property (nonatomic ,weak) id task;

@property (nonatomic ,copy) GJRequestFinishedBlock successBlock;

@property (nonatomic ,copy) GJRequestFinishedBlock failedBlock;

- (GJRequestMethod)method;

- (void)start;

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed;

- (void)cancel;

- (void)retry;

- (NSUInteger)currentRetryTimes;


//user implement methods
@optional

//default base url is setted in GJNetWorkingConfig and you can set single base url.
- (NSString *)baseUrl;

- (NSString *)path;

- (NSDictionary *)parameters;

- (NSUInteger)retryTimes;

- (NSTimeInterval)timeOutInterval;



@end
