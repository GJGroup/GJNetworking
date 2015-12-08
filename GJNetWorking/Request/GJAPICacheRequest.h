//
//  GJAPICacheRequest.h
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJBaseRequest.h"

typedef NS_ENUM(NSUInteger, GJAPICachePolicy) {
    /**
     * 不用缓存，不存缓存
     */
    GJNoAPICachePolicy,
    
    /**
     * 请求失败时使用缓存(如果缓存有效期内)，存储缓存
     */
    GJUseAPICacheWhenFailedPolicy,
    
    /**
     * 如果有缓存，则用缓存，不请求(如果缓存有效期内)，存储缓存
     */
    GJUseAPICacheIfExistPolicy,
};

//typedef NS_ENUM(NSUInteger, GJAPICacheStoragePolicy) {
//    GJNotStorageAPICachePolicy,
//    GJStorageAPICachePolicy,
//};

@interface GJAPICacheRequest : GJBaseRequest

/**
 *  接口可以自定义缓存地址
 */
- (NSString *)cacheDirectory;

/**
 * 缓存策略
 */
- (GJAPICachePolicy)cachePolicy;

/**
 * 缓存有效期,秒
 */
- (NSTimeInterval)cacheValidTime;

@end
