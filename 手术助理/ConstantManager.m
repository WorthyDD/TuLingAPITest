//
//  ConstantManager.m
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ConstantManager.h"

@interface ConstantManager()

@property (nonatomic)AFHTTPSessionManager *sessionMnager;

@end
@implementation ConstantManager

+ (instancetype)shareManager
{
    static ConstantManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        manager = [[ConstantManager alloc]init];
        manager.sessionMnager = [AFHTTPSessionManager manager];
        manager.sessionMnager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.sessionMnager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
        manager.sessionMnager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.sessionMnager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
    });
    
    return manager;
}

- (void) getOperationName:(NSString *)name completion:(void (^)(id, NSError *))completion
{
    NSString *urlStr = @"http://apis.baidu.com/tngou/operation/name";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
    Operation *op = [[Operation alloc]init];
    
    [manager GET:urlStr parameters:@{@"name" : name} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"\n\nsuccess- %@\n\n", dic);
        
        op.identifier = ((NSNumber *)[dic objectForKey:@"id"]).integerValue;
        op.count = ((NSNumber *)[dic objectForKey:@"count"]).integerValue;
        op.fCount = ((NSNumber *)[dic objectForKey:@"fcount"]).integerValue;
        op.rCount = ((NSNumber *)[dic objectForKey:@"rcount"]).integerValue;
        op.name = [dic objectForKey:@"name"];
        op.disease = [dic objectForKey:@"disease"];
        op.place = [dic objectForKey:@"place"];
        op.department = [dic objectForKey:@"department"];
        op.img = [NSString stringWithFormat:@"http://tnfs.tngou.net/img%@", [dic objectForKey:@"img"]];
        op.message = [dic objectForKey:@"message"];
        op.keyword = [dic objectForKey:@"keyword"];
        if(completion){
            completion(op,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(completion){
            completion(nil, error);
        }
        NSLog(@"\n\n fail %@\n\n", error);
    }];
    
}


- (void)getAnswer:(NSString *)words userID:(NSString *)userID completion:(void (^)(id, NSError *))completion
{
    NSString *urlStr = @"http://apis.baidu.com/turing/turing/turing";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
    
    [manager GET:urlStr parameters:@{@"info" : words,@"userid" : @"13245", @"key" : @"879a6cb3afb84dbf4fc84a1df2ab7319"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"\n\nsuccess- %@\n\n", dic);
        
        if(completion){
            completion(dic, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(completion){
            completion(nil, error);
        }
        NSLog(@"\n\n fail %@\n\n", error);
    }];
}

- (NSArray *)getPhoneContactsCompletion:(void (^)(id, NSError *))completion
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    ABAddressBookRef book = ABAddressBookCreate();
    NSMutableString *phoneStr = [[NSMutableString alloc]init];
    //等待同意后向下执行  保证只有一个线程进入
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error)                                                 {                                                     dispatch_semaphore_signal(sema);                                                 });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    
    CFArrayRef result = ABAddressBookCopyArrayOfAllPeople(book);
    for(int i = 0;i < CFArrayGetCount(result);i++){
        
        ABRecordRef person = CFArrayGetValueAtIndex(result, i);
        
        NSMutableString *name = [[NSMutableString alloc]init];
        NSString *lastname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastname != nil)
            [name appendString:lastname];
        NSString *middlename = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if(middlename != nil)
           [name appendString:middlename];
        NSString *personName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName != nil)
           [name appendString:personName];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //NSString * personPhoneLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            Contact *contact = [[Contact alloc]init];
            contact.name = name;
            personPhone = [personPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            contact.phone = personPhone;
            [phoneStr appendString:personPhone];
            [phoneStr appendString:@","];
            [arr addObject:contact];
            
        }
        CFRelease(phone);
        CFRelease(person);
    }
    CFRelease(book);
    

    if(phoneStr.length>0){
        [phoneStr replaceCharactersInRange:NSMakeRange(phoneStr.length-1, 1) withString:@""];
    }
    NSString *urlStr = @"http://apis.baidu.com/apistore/mobilenumber/mobilenumber";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
    
    [manager GET:urlStr parameters:@{@"phone" : @"15011213159,13702052513"}success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"\n\nsuccess- %@\n\n", dic);
        
        if(completion){
            completion(dic, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(completion){
            completion(nil, error);
        }
        NSLog(@"\n\n fail %@\n\n", error);
    }];
    
    return arr;
    
}

- (void)getLocationWithPhone:(NSString *)phone completion:(void (^)(id, NSError *))completion
{
    NSString *urlStr = @"http://apis.baidu.com/apistore/mobilenumber/mobilenumber";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
    
    [manager GET:urlStr parameters:@{@"phone" : phone} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"\n\nsuccess- %@\n\n", dic);
        
        if(completion){
            completion(dic, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(completion){
            completion(nil, error);
        }
        NSLog(@"\n\n fail %@\n\n", error);
    }];
}

- (void)getBeautyPictures:(NSInteger)category completion:(void (^)(id, NSError *))completion
{
    NSString *urlStr = @"http://apis.baidu.com/txapi/mvtp/meinv";
    [self.sessionMnager GET:urlStr parameters:@{@"num" : @(category)}success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"\n\nsuccess- %@\n\n", dic);
        
        if(completion){
            completion(dic, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(completion){
            completion(nil, error);
        }
        NSLog(@"\n\n fail %@\n\n", error);
    }];
}

@end
