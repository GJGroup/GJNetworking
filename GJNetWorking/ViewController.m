//
//  ViewController.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/12.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "ViewController.h"
#import "MYRequest.h"
#import "GCTestModel.h"
#import "GCStatus.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYRequest *request = [MYRequest new];
    [request startWithSuccessBlock:^(id responseObject, id status, NSError *error) {
        
        GCTestModel *model = (GCTestModel*)responseObject;
        NSLog(@"%@",model);
        
    } failedBlock:^(id responseObject, id status, NSError *error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
