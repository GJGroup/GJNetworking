//
//  MJModelMaker.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "MJModelMaker.h"
#import "MJExtension.h"
#import "GCStatus.h"

@implementation MJModelMaker

- (id)makeModelWithJSON:(NSDictionary *)json class:(Class)modelClass status:(__autoreleasing id *)status{
    GCStatus *sta = [modelClass mj_objectWithKeyValues:json];
    *status = sta;
    
    id dataJson = json[@"data"];
    if ([dataJson isKindOfClass:[NSDictionary class]]) {
        id model = [modelClass mj_objectWithKeyValues:dataJson];
        return model;
    }
    else if ([dataJson isKindOfClass:[NSArray class]]){
        NSArray *array = [modelClass mj_objectWithKeyValues:dataJson];
        return array;
    }
    
    NSLog(@"unavailable json!");
    return nil;}

@end
