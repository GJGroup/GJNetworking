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

typedef void (^GJRequestFinishedBlock)(id responseObject, NSError *error);

@protocol GJRequestProtocol;

@protocol GJRequestDelegate <NSObject>

- (void)cancelRequest:(id<GJRequestProtocol>)request;

@end


@protocol GJRequestProtocol <NSObject>

@required

@property (nonatomic, weak) id<GJRequestDelegate> delegate;

- (GJRequestMethod)method;

- (void)start;

- (void)cancel;

@optional

@property (nonatomic ,copy) GJRequestFinishedBlock successBlock;

@property (nonatomic ,copy) GJRequestFinishedBlock failedBlock;

//default base url is setted in GJNetWorkingConfig and you can set single base url.
- (NSString *)baseUrl;

- (NSString *)path;

- (NSDictionary *)parameters;

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed;



@end
