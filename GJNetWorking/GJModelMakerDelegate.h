//
//  GJModelMakerDelegate.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GJModelMakerDelegate <NSObject>

@optional

+ (id)makeModelWithJSON:(NSDictionary *)json
                  class:(Class)modelClass
               keysPath:(NSArray *)keysPath
                 status:(id __autoreleasing *)status;

@end