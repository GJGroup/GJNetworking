//
//  MantleModelMaker.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "MantleModelMaker.h"
#import "GCStatus.h"

@implementation MantleModelMaker

- (id)makeModelWithJSON:(NSDictionary *)json
                  class:(Class)modelClass
                 status:(id __autoreleasing *)status{
    
    MTLJSONAdapter *adapter = [[MTLJSONAdapter alloc] initWithModelClass:[GCStatus class]];
    GCStatus *sta = [adapter modelFromJSONDictionary:json error:nil];
    *status = sta;
    
    id dataJson = json[@"data"];
    if ([dataJson isKindOfClass:[NSDictionary class]]) {
        adapter = [[MTLJSONAdapter alloc] initWithModelClass:modelClass];
        id model = [adapter modelFromJSONDictionary:dataJson error:nil];
        return model;
    }
    else if ([dataJson isKindOfClass:[NSArray class]]){
        NSArray *array = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:dataJson error:nil];
        return array;
    }
    
    NSLog(@"unavailable json!");
    return nil;
}
//主播先去刷奶瓶
@end
