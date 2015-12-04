//
//  GCTestModel.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/18.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface GCTestModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSDictionary *loadingPage;
@property (nonatomic, copy) NSString *payBanks;
@property (nonatomic, copy) NSString *payPageRiskTips;
@property (nonatomic, copy) NSString *productListData;
@property (nonatomic, copy) NSArray *refreshData;
@property (nonatomic, copy) NSString *registerButton;
@property (nonatomic, copy) NSString *registerConfirm;
@property (nonatomic, copy) NSString *registerNext;
@property (nonatomic, copy) NSString *riskReserveFundDesc;
@property (nonatomic, copy) NSString *riskReserveFundImg;
@property (nonatomic, copy) NSString *riskReserveFundMoney;
@property (nonatomic, copy) NSString *soldOutRemind;
@property (nonatomic, copy) NSString *withdrawalBanks;

@end
