//
//  BMVvkAllFriendPhotoCollectionViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVvkAllFriendPhotoCollectionView.h"
#import "BMVvkPhotoModel.h"
#import "BMVvkUserModel.h"
#import "BMVvkPhotosCollectionViewCell.h"
#import "LocalVKToken.h"
#import "BMVgetPhotosJSONData.h"



NSString * const identifierCell = @"identifierCellSelf";
NSInteger const offsetLeft = 20;
NSInteger const offsetTop = 5;

@interface BMVvkAllFriendPhotoCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSUInteger numberPage;
@property (nonatomic, copy) BMVvkUserModel *viewedUser;
@property (nonatomic, copy) NSMutableArray <BMVvkPhotoModel *> *modelArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
//@property (nonatomic, strong) NetworkSession *networkSession;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation BMVvkAllFriendPhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _numberPage = 1;
        _modelArray = [NSMutableArray new];
        _viewedUser = [BMVvkUserModel new];
        self.backgroundColor = UIColor.whiteColor;
        
        self.delegate = self;
        self.dataSource = self;
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing = 2.f;
        flowLayout.minimumLineSpacing = 2.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds)/3-2, CGRectGetWidth(self.bounds)/3-2);
        self.collectionViewLayout = flowLayout;
        [self registerClass:[BMVvkPhotosCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    }
    return self;
}

- (void)gettingAllUsersPhoto:(BMVvkUserModel *)currentUser token:(LocalVKToken *)token
{
    [self.modelArray removeAllObjects];
    self.numberPage = 1;
    
    [BMVgetPhotosJSONData NetworkWorkingWithPhotosJSON:token currentFriend:currentUser completeBlock:^(NSMutableArray <BMVvkPhotoModel *> *photos)
     {
         self.modelArray = photos;
         [self reloadData];
     }];
    
    

}







#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BMVvkPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    // Configure the cell
    
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

