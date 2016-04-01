//
//  Operation.h
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Operation : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger fCount;
@property (nonatomic, assign) NSInteger rCount;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *department;
@property (nonatomic) NSString *disease;
@property (nonatomic) NSString *img;
@property (nonatomic) NSString *des;
@property (nonatomic) NSString *place;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *keyword;

@end
