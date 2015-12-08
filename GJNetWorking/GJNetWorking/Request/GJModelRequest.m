//
//  GJModelRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJModelRequest.h"
#import "GJNetworkingConfig.h"

@implementation GJModelRequest

- (void)setSuccessBlock:(GJRequestFinishedBlock)successBlock {
    __weak typeof(self) weakSelf = self;
    
    [super setSuccessBlock:^(id responseJson, id status , NSError *error){
        
        //make model
        BOOL success = error ? NO : YES;
        id responseStatus;
        id responseObject = responseJson;
        
        //if request success and request implement modelClass,
        //when request or default modelMaker implement the delegate ,
        //the response object will be make to model or model list.
        if (success && [weakSelf respondsToSelector:@selector(modelClass)]){
            Class defaultModelMaker = [GJNetworkingConfig modelMaker];
            Class modelMaker = nil;
            if (weakSelf && [[weakSelf class] respondsToSelector:@selector(makeModelWithJSON:class:status:)] &&
                [[weakSelf class] conformsToProtocol:@protocol(GJModelMakerDelegate)]) {
                modelMaker = [weakSelf class];
            }
            else if (defaultModelMaker && [defaultModelMaker respondsToSelector:@selector(makeModelWithJSON:class:status:)] &&
                     [defaultModelMaker conformsToProtocol:@protocol(GJModelMakerDelegate)]){
                modelMaker = defaultModelMaker;
            }
            
            if (modelMaker) {
                responseObject = [modelMaker makeModelWithJSON:responseObject
                                                         class:[weakSelf modelClass]
                                                        status:&responseStatus];
            }
            
        }
        
        !successBlock ? : successBlock(responseObject , responseStatus, error);
        
    }];

}


@end
