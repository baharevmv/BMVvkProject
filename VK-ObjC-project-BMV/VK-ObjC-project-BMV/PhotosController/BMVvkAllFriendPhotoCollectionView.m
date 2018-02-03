//
//  BMVvkAllFriendPhotoCollectionViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVvkAllFriendPhotoCollectionView.h"
#import "BMVvkPhotosCollectionViewCell.h"
#import "BMVVkPhotoModel.h"
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"
#import "BMVgetPhotosJSONData.h"

static NSString *cellIdentifier = @"CellIdentifier";
NSInteger const offsetLeft = 20;
NSInteger const offsetTop = 5;

@interface BMVvkAllFriendPhotoCollectionView ()

//@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) NSUInteger numberPage;
@property (nonatomic, copy) BMVVkUserModel *viewedUser;
@property (nonatomic, copy) NSMutableArray <BMVVkPhotoModel *> *modelArray;
@property (nonatomic, retain) NSMutableArray <BMVVkPhotoModel *> *selectedModelArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic) NSMutableArray  *arrayWithSelectedIndexPath;


@end

@implementation BMVvkAllFriendPhotoCollectionView


- (void) viewDidLoad
{
    self.arrayWithSelectedIndexPath = [NSMutableArray new];
    self.selectedModelArray = [NSMutableArray <BMVVkPhotoModel *> new];
    [super viewDidLoad];
    // Собираем модель
    [self gettingAllUsersPhoto:self.interestingUser token:self.tokenForFriendsController];
    // Настраиваем flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 2.0f;
    flowLayout.minimumLineSpacing = 2.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    flowLayout.itemSize = CGSizeMake(100, 100);
    self.collectionView.collectionViewLayout = flowLayout;
    
    // Настраиваем collectionView
    [self.collectionView registerClass:[BMVvkPhotosCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAllPhotos)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"DOWNLOADED");
        return;
    }
    NSLog(@"We got an Error here - %@", error);
}
- (void) downloadAllPhotos
{
    // network animation on
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // save image from the web
    NSLog(@"КОЛИЧЕСТВО %lu",(unsigned long)self.selectedModelArray.count);
    if (self.selectedModelArray.count != 0 )
    {
        NSLog(@"%@", self.selectedModelArray);
        for (BMVVkPhotoModel *photo in self.selectedModelArray)
        {
            NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"%@", originalPhotoPath);
                UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:originalPhotoPath]]];
                SEL _imageDownloaded= @selector(image:didFinishSavingWithError:contextInfo:);
                UIImageWriteToSavedPhotosAlbum(downloadedImage, self, _imageDownloaded, nil);
            });
        }
    } else {
        NSLog(@"%@", self.modelArray);
        for (BMVVkPhotoModel *photo in self.modelArray)
        {
            NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                NSLog(@"%@", originalPhotoPath);
                UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:originalPhotoPath]]];
                SEL _imageDownloaded= @selector(image:didFinishSavingWithError:contextInfo:);
                UIImageWriteToSavedPhotosAlbum(downloadedImage, self, _imageDownloaded, nil);
                });
            });
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)gettingAllUsersPhoto:(BMVVkUserModel *)currentUser token:(BMVVkTokenModel *)token
{
    [self.modelArray removeAllObjects];
    
    [BMVgetPhotosJSONData NetworkWorkingWithPhotosJSON:token currentFriend:currentUser completeBlock:^(NSMutableArray <BMVVkPhotoModel *> *photos)
     {
         self.modelArray = photos;
        [self.collectionView reloadData];
     }];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BMVvkPhotosCollectionViewCell *collectionViewCell = (BMVvkPhotosCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    [collectionViewCell prepareForReuse];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *previewPhotoPath = [[NSString alloc] initWithFormat:@"%@",self.modelArray[indexPath.row].previewImageURL];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: previewPhotoPath]];
            dispatch_async(dispatch_get_main_queue(), ^{
                collectionViewCell.image = [UIImage imageWithData: imageData];
            });
    });
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedModelArray addObject:self.modelArray[indexPath.item]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAllPhotos)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedModelArray removeObject:self.modelArray[indexPath.item]];
}

@end
