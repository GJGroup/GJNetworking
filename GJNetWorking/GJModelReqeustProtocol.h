//
//  GJModelReqeustProtocol.h
//  GJNetWorking
//
//  Created by wangyutao on 15/12/8.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJRequestProtocol.h"

@protocol GJModelReqeustProtocol <GJRequestProtocol>

@optional
//if you want to make model call back, you must implement this method for makeModel Protocol.
- (Class)modelClass;

@end
