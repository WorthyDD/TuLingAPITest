//
//  ConstantManager.h
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Operation.h"
#import <AddressBook/AddressBook.h>
#import "Contact.h"

static NSString *kAPIKey = @"902e4f59a69d4f2a21158b12eb8fa2de";

@interface ConstantManager : NSObject


+ (instancetype) shareManager;

/**
 *  获取手术信息
 */
- (void) getOperationName : (NSString *)name completion : (void (^)(id result, NSError *err))completion;


/**
 *  图灵机器人
 */
- (void) getAnswer : (NSString *)words userID: (NSString *)userID completion : (void (^)(id result, NSError *err))completion;

/**
 *  通讯录
 */
- (NSArray *) getPhoneContactsCompletion : (void (^)(id result, NSError *err))completion;

/**
 *  查询归属地
 */
- (void) getLocationWithPhone : (NSString *)phone completion : (void (^)(id result, NSError *err))completion;

/**
 *  美女图片
 */

- (void) getBeautyPictures : (NSInteger) category completion : (void (^)(id result, NSError *err))completion;
@end
