//
//  BeautyCollectionViewController.m
//  手术助理
//
//  Created by 武淅 段 on 16/4/1.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "BeautyCollectionViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BeautyCollectionViewController ()

@property (nonatomic) NSMutableArray *picURLArray;
@end

@implementation BeautyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat gap = 2;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-gap*3)/4, (SCREEN_WIDTH-gap*3)/4);
    layout.minimumInteritemSpacing = 2;
    
    _picURLArray  = [[NSMutableArray alloc]init];
    
    __weak typeof(self) WeakSelf = self;
    for(int i = 0; i < 10; i++){
        [[ConstantManager shareManager]getBeautyPictures:i completion:^(id result, NSError *err) {
           
            NSLog(@"\n\n\nis in main thread %d\n\n\n", [NSThread isMainThread]);
            if(result){
                
                NSArray *arr = [result objectForKey:@"newslist"];
                for(NSDictionary *dic in arr){
                    NSString *url = [dic objectForKey:@"picUrl"];
                    if(url){
                        
                        [WeakSelf.picURLArray addObject:url];
                        
                    }
                }
                [WeakSelf.collectionView reloadData];
            }
        }];
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _picURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *url = _picURLArray[indexPath.row];
    
    if(cell.subviews.count<=1){
        UIImageView *iv = [[UIImageView alloc]initWithFrame:cell.bounds];
        [cell addSubview:iv];
    }
    
    for(UIView *iv in cell.subviews){
        
        NSLog(@"\n\ncell %@\n\n", iv);
        if([iv isKindOfClass:[UIImageView class]]){
            
            UIImageView *iv1 = (UIImageView *)iv;
            
//            [iv1 setImageWithURL:[NSURL URLWithString:url]];
//            [iv1 setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            NSString* webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];      //解决包含中文的bug
            NSURL *urlS = [NSURL URLWithString:webStringURL];
            if(urlS){
                [iv1 setImageWithURL:urlS];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSURL *imURL = [NSURL URLWithString:webStringURL];
//                NSData *data = [NSData dataWithContentsOfURL:imURL];
//                [iv1 setImage:[UIImage imageWithData:data]];
//    
//            });
        }
    }
   
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
