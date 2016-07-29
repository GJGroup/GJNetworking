//
//  GJRequestGroup.h
//  Pods
//
//  Created by wangyutao on 16/5/7.
//
//

#import <Foundation/Foundation.h>

@class GJBaseRequest;
@interface GJRequestGroup : NSObject

+ (void)startWithRequests:(NSArray *)requests
                 finished:(void (^)(NSArray<GJBaseRequest *> *requests))finished;

@end
