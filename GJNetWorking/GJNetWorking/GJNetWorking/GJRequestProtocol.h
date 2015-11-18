//
//  GJRequestProtocol.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJModelMakerDelegate.h"

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


@end


@protocol GJRequestProtocol <GJModelMakerDelegate>


@property (nonatomic, weak) id<GJRequestDelegate> delegate;

@property (nonatomic ,weak) id task;

- (GJRequestMethod)method;

- (void)start;

- (void)cancel;

- (void)retry;

- (NSUInteger)currentRetryTimes;

@optional

@property (nonatomic ,copy) GJRequestFinishedBlock successBlock;

@property (nonatomic ,copy) GJRequestFinishedBlock failedBlock;

//the real task object, we use 'id' because we don't want ref specific object.

//if you want to make model call back, you must implement this method for makeModel Protocol.
- (Class)modelClass;

//default base url is setted in GJNetWorkingConfig and you can set single base url.
- (NSString *)baseUrl;

- (NSString *)path;

- (NSDictionary *)parameters;

- (NSUInteger)retryTimes;

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed;



@end
