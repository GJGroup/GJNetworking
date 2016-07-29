//
//  GJRequestGroup.m
//  Pods
//
//  Created by wangyutao on 16/5/7.
//
//

#import "GJRequestGroup.h"
#import "GJBaseRequest.h"

@implementation GJRequestGroup

+ (void)startWithRequests:(NSArray *)requests
                 finished:(void (^)(NSArray<GJBaseRequest *> *))finished {
    
    if (requests.count == 0) {
        !finished ? : finished(requests);
    }
    
    dispatch_group_t group = dispatch_group_create();

    for (GJBaseRequest *request in requests) {
        dispatch_group_enter(group);
        [request startWithCompletedBlock:^(GJBaseRequest *request) {
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        !finished ? : finished(requests);
    });
    
}
@end
