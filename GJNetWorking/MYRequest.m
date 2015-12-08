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
    return @{@"channelId":@"E66C5A44DE9841CC70C3DBD51560EC2B",
            @"clientType":@"1",
            @"sign":@"b28e3b36bf836b8176b583538ea3f406"};
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
