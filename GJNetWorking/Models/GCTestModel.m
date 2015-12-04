//
//  GCTestModel.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/18.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GCTestModel.h"

@implementation GCTestModel

//mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"loadingPage":@"loadingPage",
             @"payBanks":@"payBanks",
             @"payPageRiskTips":@"payPageRiskTips",
             @"productListData":@"productListData",
             @"refreshData":@"refreshData",
             @"registerButton":@"registerButton",
             @"registerConfirm":@"registerConfirm",
             @"registerNext":@"registerNext",
             @"riskReserveFundDesc":@"riskReserveFundDesc",
             @"riskReserveFundImg":@"riskReserveFundImg",
             @"riskReserveFundMoney":@"riskReserveFundMoney",
             @"soldOutRemind":@"soldOutRemind",
             @"withdrawalBanks":@"withdrawalBanks",
             };
}

//mj
+ (NSDictionary *)replacedKeyFromPropertyName {
    return [self JSONKeyPathsByPropertyKey];
}
@end
