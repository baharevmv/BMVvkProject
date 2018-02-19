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
static CGFloat const BMVActivityOffset = 150.0;
static CGFloat const BMVLoadingLabelOffset = 20.0;
static CGFloat const BMVFlowLayoutSpacing = 2.0;
static CGFloat const BMVFlowLayoutSizes = 100.0;
static CGFloat const BMVLoadingViewCornerRadius = 10.0;
static CGFloat const BMVActivityViewDimension = 40.0;


@interface BMVvkAllFriendPhotoCollectionView ()

@property (nonatomic, copy) NSArray <BMVVkPhotoModel *> *modelArray;
@property (nonatomic, strong) NSMutableArray <BMVVkPhotoModel *> *selectedModelArray;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIView *loadingView;


@end


@implementation BMVvkAllFriendPhotoCollectionView


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUserInterface];
    [self preparingModel];
    self.selectedModelArray = [NSMutableArray <BMVVkPhotoModel *> new];
    // Pull-to-Refresh Feature
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Обновляем..."];
    [refreshControl addTarget:self action:@selector(refreshWithPull:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(savePhotosToPhone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark - Working With UI

- (void)createUserInterface
{
    // Настраиваем flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = BMVFlowLayoutSpacing;
    flowLayout.minimumLineSpacing = BMVFlowLayoutSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    flowLayout.itemSize = CGSizeMake(BMVFlowLayoutSizes, BMVFlowLayoutSizes);
    self.collectionView.collectionViewLayout = flowLayout;
    
    // Настраиваем collectionView
    [self.collectionView registerClass:[BMVvkPhotosCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Создаем спиннер
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(BMVActivityOffset*1.5, BMVActivityOffset,
                                                                CGRectGetWidth(self.view.frame) - BMVActivityOffset*1.5,
                                                                BMVActivityOffset)];
    self.loadingView.center = self.view.center;
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = BMVLoadingViewCornerRadius;
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(BMVLoadingLabelOffset*1.5, BMVLoadingLabelOffset*5.75,
                                                                  BMVLoadingLabelOffset *6.5, BMVLoadingLabelOffset)];
    self.loadingLabel.center = CGPointMake(CGRectGetWidth(self.loadingView.bounds)/2, BMVLoadingLabelOffset*5.75);
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = @"Загружаем...";
    [self.loadingView addSubview:self.loadingLabel];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.frame = CGRectMake(CGRectGetWidth(self.loadingView.frame)/2 - self.activityView.bounds.size.width/2, BMVActivityViewDimension, self.activityView.bounds.size.width, self.activityView.bounds.size.height);
    [self.loadingView addSubview:self.activityView];
}


- (void)refreshWithPull:(UIRefreshControl *)refreshControl
{
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypePhotos localToken:self.tokenForFriendsController
                                    currentUserID:self.interestingUser.userID completeHandler:^(id photoModelArray) {
        self.modelArray = photoModelArray;
        [self.collectionView reloadData];
    }];
    [refreshControl endRefreshing];
}


#pragma mark - Working With Network

- (void)downloadAllPhotosWithArray:(NSArray *)arrayWithModel
{
    [self.downloadDataService downloadAllPhotosToPhotoAlbumWithArray:arrayWithModel completeHandler:^(id any) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityView stopAnimating];
            [self.loadingView removeFromSuperview];
            NSLog(@"Задание на загрузку выполнено");
        });
    }];
    
}


- (void)savePhotosToPhone
{
    [self.view addSubview:self.loadingView];
    [self.activityView startAnimating];
    NSArray *arrayToDownload = [NSArray new];
    arrayToDownload = (self.selectedModelArray.count != 0 ) ? self.selectedModelArray : self.modelArray;
        [self downloadAllPhotosWithArray:arrayToDownload];
}


- (void)preparingModel
{
    self.downloadDataService = [BMVDownloadDataService new];
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypePhotos
                                                  localToken:self.tokenForFriendsController
                                               currentUserID:self.interestingUser.userID
        completeHandler:^(id photoModelArray) {
        self.modelArray = photoModelArray;
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionView Required Methods

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
    BMVvkPhotosCollectionViewCell *collectionViewCell = (BMVvkPhotosCollectionViewCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *previewPhotoPath = [[NSString alloc] initWithFormat:@"%@",self.modelArray[indexPath.row].previewImageURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: previewPhotoPath]];
            dispatch_async(dispatch_get_main_queue(), ^{
                collectionViewCell.image = [UIImage imageWithData: imageData];
            });
    });
    return collectionViewCell;
}


#pragma mark - UITableView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedModelArray addObject:self.modelArray[indexPath.item]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(savePhotosToPhone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedModelArray removeObject:self.modelArray[indexPath.item]];
    if (self.selectedModelArray.count == 0)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(savePhotosToPhone)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}


@end
