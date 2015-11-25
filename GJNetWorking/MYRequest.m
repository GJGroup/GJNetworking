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
    return @"";
}

- (NSDictionary *)parameters{
    return @{@"channelId":@"abc",
            @"clientType":@"1",
            @"sign":@"bcd"};
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [GCTestModel class];
}

@end
