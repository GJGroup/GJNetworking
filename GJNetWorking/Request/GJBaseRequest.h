//
//  GJBaseRequest.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJRequestProtocol.h"

@class AFHTTPRequestOperation;

typedef NS_ENUM(NSUInteger, GJRequestMethod) {
    GJRequestGET,
    GJRequestPOST,
    GJRequestHEAD,
    GJRequestPUT,
    GJRequestPATCH,
    GJRequestDELET
};

typedef NS_ENUM(NSUInteger, GJRequestState) {
    GJRequestStateReady,
    GJRequestStateExcuting,
    GJRequestStateCanceled,
    GJRequestStateFinished
};

typedef NS_ENUM(NSUInteger, GJResponseType) {
    GJResponseTypeDefault,  //default is json
    GJResponseTypeImage     //this is return image object response type
};



typedef void (^GJCompletedBlock)(GJBaseRequest * request);
typedef void (^GJRequestFinishedBlock)(id responseObject, id status , NSError *error);
typedef void (^GJDNSBlock)(BOOL usedDNs, NSString *domain, NSString *newBaseUrl);


@interface GJBaseRequest : NSObject 

@property (nonatomic, weak) id<GJRequestDelegate> delegate;

/**
 *  request的状态，（准备，执行中，被取消，结束）
 */
@property (nonatomic, readonly) GJRequestState state;

/**
 *  请求的任务，目前主要是operation，以后可能会换成session
 */
@property (nonatomic, strong) NSURLSessionTask *task;

/**
 *  请求结束block，参数是当前request
 */
@property (nonatomic, copy, readonly) GJCompletedBlock completedBlock;

/**
 *  请求成功的block
 */
@property (nonatomic, copy, readonly) GJRequestFinishedBlock successBlock;

/**
 *  请求失败的block
 */
@property (nonatomic, copy, readonly) GJRequestFinishedBlock failedBlock;
//@property (nonatomic, strong) NSMutableDictionary *HTTPRequestHeaders;
/**
 *  当前请求重试次数
 */
@property (nonatomic, assign, readonly) NSUInteger currentRetryTimes;

/**
 *  请求error
 */
@property (nonatomic, readonly, strong) NSError *error;

/**
 *  请求返回的object，根据request设置可以为json也可为model
 */
@property (nonatomic, readonly, strong) id responseObject;

/**
 *  请求返回的object，纯json
 */
@property (nonatomic, readonly, strong) id responseJson;

/**
 *  请求方法
 */
- (GJRequestMethod)method;

/**
 *  发出请求的方法，参数是回调block，不区分成功失败，可从request的属性中取到，更为灵活
 */
- (void)startWithCompletedBlock:(GJCompletedBlock)completedBlock;

/**
 *  取消请求
 */
- (void)cancel;

/**
 *  请求是否成功，主要依据error来判断是否成功
 */
- (BOOL)isRequestSuccessed;

/**
 *  请求是否被cancel
 */
- (BOOL)isCanceled;

/**
 *  请求是否在执行中
 */
- (BOOL)isNetworking;

#pragma mark - user implement methods
//default base url is setted in GJNetWorkingConfig and you can set single base url.
/**
 *  请求服务器的baseUrl
 */
- (NSString *)baseUrl;

/**
 *  请求服务器的路径
 */
- (NSString *)path;

/**
 *  请求的参数
 */
- (NSDictionary *)parameters;

/**
 *  返回的类型
 */
- (GJResponseType)responseType;

/**
 *  请求的重试次数，默认为0
 */
- (NSUInteger)retryTimes;

/**
 *  请求的超时时间，默认为20秒
 */
- (NSTimeInterval)timeOutInterval;

/**
 *  选择实现此方法，在使用baseUrl前调用，主要为了项目中处理DNS问题，选择是使用IP还是域名
 */
- (void)dNSWithBaseUrl:(NSString *)baseUrl dNSBlock:(GJDNSBlock)dnsBlock;


#pragma mark- Pravite Method
/**
 *  请求成功后，callback之前会调用此方法，子类处理很多数据逻辑，重写请慎重
 */
- (void)requestCompleted;

/**
 *  发出请求
 */
- (void)start;

/**
 *  请求重试
 */
- (void)retry;

/**
 *  请求结束后的统一回调，请勿重写
 */
- (void)requestTerminate;

- (BOOL)shouldRetryWithResponseObject:(id)responseObject
                                error:(NSError *)error;


#pragma mark- deprecated
/**
 *  发出请求的方法，参数是回调block
 */
- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed __attribute__((deprecated("Replaced by -startWithCompletedBlock:")));
;
@end
