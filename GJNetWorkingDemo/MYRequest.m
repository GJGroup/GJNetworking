//
//  MYRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/16.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "MYRequest.h"
#import "GCTestModel.h"

@implementation MYRequest

- (NSString *)path{
    return @"p2pInitController/getInitData.action";
}

- (NSDictionary *)parameters{
    return @{@"channelId":@"4C9EF1676B564240DF6AA684F968E85A",
            @"clientType":@"1",
            @"sign":@"98793ef4c0cc1f153361e47e7e5c5efc"};
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [GCTestModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJUseAPICacheIfExistPolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 60 * 60;
}

@end
