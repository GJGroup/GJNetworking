//
//  GCStatus.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface GCStatus : MTLModel

@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *result;

@end
