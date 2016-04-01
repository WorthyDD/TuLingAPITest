//
//  PhoneTableViewController.m
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "PhoneTableViewController.h"

@interface PhoneTableViewController ()

@property (nonatomic) NSArray *phoneArray;
@end

@implementation PhoneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) WeakSelf = self;
    NSArray *phones = [[ConstantManager shareManager]getPhoneContactsCompletion:^(id result, NSError *err) {
        
        if(result){
            NSArray *data = [result objectForKey:@"data"];
            for(NSDictionary *dic in data){
                NSString *province = [dic objectForKey:@"province"];
                NSString *city = [dic objectForKey:@"city"];
                NSString *phone = [dic objectForKey:@"phone"];
                NSLog(@"\n\n\n%is in main thread  ld\n\n\n",[NSThread isMainThread]);
                for(Contact *contact in WeakSelf.phoneArray){
                    if([contact.phone isEqualToString:phone]){
                        contact.location = [NSString stringWithFormat:@"%@ %@",province,city];
                    }
                }
            }
            
            [WeakSelf.tableView reloadData];
        }
    }];
    _phoneArray = phones;
    [self.tableView reloadData];
    for(int i = 0; i < phones.count; i++){
        
        Contact *contact = _phoneArray[i];
        [[ConstantManager shareManager]getLocationWithPhone:contact.phone completion:^(id result, NSError *err) {
           
            if(result){
                
                NSDictionary *data = [result objectForKey:@"retData"];
                if(data.count>0){
                    NSString *province = [data objectForKey:@"province"];
                    NSString *city = [data objectForKey:@"city"];
                    contact.location = [NSString stringWithFormat:@"%@ %@",province,city];
                    NSLog(@"\n\n %@ \n\n", contact.location);
                   // NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    //[WeakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                    [WeakSelf.tableView reloadData];
                }
            }
            if(err){
                
                NSLog(@"\n\nerror %@\n\n", err);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _phoneArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Contact *contact = _phoneArray[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@    %@",contact.phone,contact.name]];
    [cell.detailTextLabel setText:contact.location?:@""];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
