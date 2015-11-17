//
//  GJModelMaker.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJModelMaker.h"
#import <objc/runtime.h>

@implementation GJModelMaker

- (id)makeModelWithJSON:(NSDictionary *)json
               keysPath:(NSArray *)keysPath
                  class:(__unsafe_unretained Class)modelClass
{
    if (!json) return nil;
    
    NSString *key = keysPath.firstObject;
    NSDictionary *dic = json;
    
    while (key.length) {
        dic = dic[key];
        
    }
    
    
    
    return nil;
}



@end
