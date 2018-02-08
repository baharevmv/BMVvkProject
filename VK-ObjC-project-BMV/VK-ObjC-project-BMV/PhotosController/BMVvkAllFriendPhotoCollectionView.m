//
//  BMVvkAllFriendPhotoCollectionViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "QuartzCore/QuartzCore.h"
#import "BMVvkAllFriendPhotoCollectionView.h"
#import "BMVvkPhotosCollectionViewCell.h"
#import "BMVVkPhotoModel.h"
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"
#import "BMVDownloadDataService.h"


static NSString *cellIdentifier = @"CellIdentifier";
NSInteger const offsetLeft = 20;
NSInteger const offsetTop = 5;


@interface BMVvkAllFriendPhotoCollectionView ()


@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, assign) NSUInteger numberPage;
@property (nonatomic, copy) BMVVkUserModel *viewedUser;
@property (nonatomic, strong) NSMutableArray <BMVVkPhotoModel *> *modelArray;
@property (nonatomic, retain) NSMutableArray <BMVVkPhotoModel *> *selectedModelArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;


@end


@implementation BMVvkAllFriendPhotoCollectionView


- (void) viewDidLoad
{
    // Pull-to-Refresh Feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."];
    [refreshControl addTarget:self action:@selector(refreshWithPull:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.selectedModelArray = [NSMutableArray <BMVVkPhotoModel *> new];
    [super viewDidLoad];
    // Собираем модель
    self.downloadDataService = [BMVDownloadDataService new];
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypePhotos queue:nil
                                                  localToken:self.tokenForFriendsController
                                               currentUserID:self.interestingUser.userID
                                             completeHandler:^(id photoModelArray) {
        self.modelArray = photoModelArray;
//        [self.spinner stopAnimating];
        [self.collectionView reloadData];
    }];
    
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
    
    // Создаем спиннер
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = @"Загружаем...";
    [self.loadingView addSubview:self.loadingLabel];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.frame = CGRectMake(65, 40, self.activityView.bounds.size.width, self.activityView.bounds.size.height);
    [self.loadingView addSubview:self.activityView];
    
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(downloadPhotosToPhone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)refreshWithPull:(UIRefreshControl *)refreshControl
{
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypePhotos queue:nil
                                                  localToken:self.tokenForFriendsController
                                               currentUserID:self.interestingUser.userID
                                             completeHandler:^(id photoModelArray) {
        self.modelArray = photoModelArray;
        [self.collectionView reloadData];
    }];
    [refreshControl endRefreshing];
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

- (void) downloadPhotosToPhone
{
    // network animation
    [self.view addSubview:self.loadingView];
    [self.activityView startAnimating];
    
    // save image from the web
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.selectedModelArray.count != 0 )
        {
            [self.downloadDataService downloadAllPhotosToPhotoAlbumWithArray:self.selectedModelArray completeHandler:^(id any) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityView stopAnimating];
                    [self.loadingView removeFromSuperview];
                    NSLog(@"Задание на загрузку выполнено");
                });
            }];
        }
        else
        {
            [self.downloadDataService downloadAllPhotosToPhotoAlbumWithArray:self.modelArray completeHandler:^(id any) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityView stopAnimating];
                    [self.loadingView removeFromSuperview];
                    NSLog(@"Задание на загрузку выполнено");
                });
            }];
        }
    });
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
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
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(downloadPhotosToPhone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedModelArray removeObject:self.modelArray[indexPath.item]];
    if (self.selectedModelArray.count == 0)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(downloadPhotosToPhone)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
        
}

@end
