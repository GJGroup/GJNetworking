//
//  GJModelMakerDelegate.h
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GJModelMakerDelegate <NSObject>

- (id)makeModelWithJSON:(NSDictionary *)json
               keysPath:(NSArray *)keysPath
                  class:(Class)modelClass;

@end