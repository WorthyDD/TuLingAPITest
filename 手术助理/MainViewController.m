//
//  MainViewController.m
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*[[ConstantManager shareManager] getOperationName:@"心脏搭桥手术" completion:^(id result, NSError *err) {
        
        if(result){
            
            Operation *op = result;
            NSLog(@"\n\nsuccess-%@\n\n",op.description);
        }
        if(err){
            NSLog(@"\n\nerror-%@\n\n",err);
        }
    }];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
