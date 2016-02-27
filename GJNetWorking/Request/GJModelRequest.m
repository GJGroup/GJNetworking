//
//  GJModelRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/12/1.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJModelRequest.h"
#import "GJNetworkingConfig.h"

@interface GJModelRequest ()

@property (nonatomic, readwrite, strong) id responseModel;
@property (nonatomic, readwrite, strong) id status;

@end

@implementation GJModelRequest

- (id)responseObject {
    if (self.responseModel) {
        return self.responseModel;
    }
    return [super responseObject];
}

- (void)requestCompleted{
    
    [super requestCompleted];
    
    BOOL success = !self.error;
    
    id responseStatus;
    id responseObject = self.responseObject;

    //if request success and request implement modelClass,
    //when request or default modelMaker implement the delegate ,
    //the response object will be make to model or model list.
    if (success && [self respondsToSelector:@selector(modelClass)]){
        Class defaultModelMaker = [GJNetworkingConfig modelMaker];
        Class modelMaker = nil;
        if (self && [[self class] respondsToSelector:@selector(makeModelWithJSON:class:status:)] &&
            [[self class] conformsToProtocol:@protocol(GJModelMakerDelegate)]) {
            modelMaker = [self class];
        }
        else if (defaultModelMaker && [defaultModelMaker respondsToSelector:@selector(makeModelWithJSON:class:status:)] &&
                 [defaultModelMaker conformsToProtocol:@protocol(GJModelMakerDelegate)]){
            modelMaker = defaultModelMaker;
        }
        
        if (modelMaker) {
            self.responseModel = [modelMaker makeModelWithJSON:responseObject
                                                         class:[self modelClass]
                                                        status:&responseStatus];
            self.status = responseStatus;
        }
        
    }

}

@end
