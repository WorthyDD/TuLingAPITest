//
//  RobotViewController.m
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "RobotViewController.h"


@interface RobotViewController ()

@property (weak, nonatomic) IBOutlet UILabel *anserLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation RobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)keyboardWillShow : (NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"\n\n show size %@\n\n", NSStringFromCGSize(kbSize));
    self.view.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height/2-kbSize.height);
}
- (void)keyboardShow : (NSNotification *)notification
{
    
}
- (void)keyboardWillHide : (NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"\n\n hide size %@\n\n", NSStringFromCGSize(kbSize));
    self.view.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height/2);
}
- (void)keyboardHide : (NSNotification *)notification
{
    
}

- (IBAction)didTapSend:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[ConstantManager shareManager]getAnswer:_textField.text userID:@"12345" completion:^(id result, NSError *err) {
        if(result){
            NSLog(@"\n\nsuccess-%@\n\n",result);
            NSString *showText = [result objectForKey:@"text"];
            [weakSelf.anserLabel setText:showText];
        }
        if(err){
            NSLog(@"\n\nerror-%@\n\n",err);
        }
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
