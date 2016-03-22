//
//  GJModelRequest.h
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJAPICacheRequest.h"
#import "GJModelMakerDelegate.h"

@interface GJModelRequest : GJAPICacheRequest <GJModelMakerDelegate>

/**
 *  请求返回的model，如果开启自动转换model功能
 */
@property (nonatomic, readonly, strong) id responseModel;

/**
 *  请求返回的状态，如果开启自动转换功能
 */
@property (nonatomic, readonly, strong) id status;

/**
 *  如果想自动转换model，则需要实现此方法，返回需要转换的model类型
 *  同时也必须指定modelMaker
 */
- (Class)modelClass;

/**
 *  modelMaker中可以根据这个返回的参数来进行解析
 *
 *  @return [@"data","modelList"];
 */
- (NSArray<NSString *> *)modelKeysPath;

@end
