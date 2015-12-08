//
//  GJModelRequest.h
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJAPICacheRequest.h"
#import "GJModelMakerDelegate.h"
#import "GJModelReqeustProtocol.h"

@interface GJModelRequest : GJAPICacheRequest <GJModelMakerDelegate,GJModelReqeustProtocol>

@end
