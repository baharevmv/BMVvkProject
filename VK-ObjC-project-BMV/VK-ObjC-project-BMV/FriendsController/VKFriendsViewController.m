//
//  BMVvkFriendsViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "VKFriendsViewController.h"
#import "VKFriendsTableViewCell.h"
#import "BMVVkUserModel.h"
#import "BMVvkAllFriendPhotoCollectionView.h"
#import "BMVCoreDataDownloadFunnel.h"
#import "BMVCoreDataService.h"

#import "BMVDownloadDataService.h"

CGFloat const offsetNavBar = 76;
static NSString *const cellIdentifier = @"cellIdentifier";


@interface VKFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) BMVCoreDataDownloadFunnel *coreDataDownloadFunnel;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVVkUserModel *dataFriendModel;
@property (nonatomic, copy) NSArray *friendsArray;
@property (nonatomic, strong) VKFriendsTableViewCell *tableViewCell;
@property (nonatomic, strong) NSArray <BMVVkUserModel *> *usersArray;
@property (nonatomic, strong) BMVvkAllFriendPhotoCollectionView *photosOfThisFriend;
//@property (nonatomic, assign) BOOL firstAppearance;


@end


@implementation VKFriendsViewController


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _coreDataDownloadFunnel = [BMVCoreDataDownloadFunnel new];
        _downloadDataService = [BMVDownloadDataService new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // PullToRefresh функция
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView registerClass:[VKFriendsTableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    self.navigationItem.title = @"Friends";
//    self.firstAppearance = YES;
    [self.activityIndicatorView startAnimating];
    [self downloadDataForFriendsTableView];
    
//    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends queue:nil localToken:self.tokenForFriendsController currentUserID:self.tokenForFriendsController.userIDString completeHandler:^(id modelArray) {
//        self.usersArray = modelArray;
//        [self.activityIndicatorView stopAnimating];
//        [self.tableView reloadData];
//    }];
}

- (void)downloadDataForFriendsTableView
{
    [self.activityIndicatorView startAnimating];
    [self.coreDataDownloadFunnel obtainVKFriendsWithLocalToken:self.tokenForFriendsController CompleteHandler:^(id dataModel) {
                                                         self.usersArray = dataModel;
                                                         [self.activityIndicatorView stopAnimating];
                                                            [self.tableView reloadData];
                                                     }];
}




- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends queue:nil localToken:self.tokenForFriendsController currentUserID:self.tokenForFriendsController.userIDString completeHandler:^(id modelArray) {
        self.usersArray = modelArray;
        BMVCoreDataService *coreDataService = [BMVCoreDataService new];
        [coreDataService saveFriendModel:modelArray];
        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VKFriendsTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    // Забираем имя
    NSString *friendFullName = [[NSString alloc] initWithFormat:@"%@ %@",self.usersArray[indexPath.row].firstName, self.usersArray[indexPath.row].lastName];
    tableViewCell.userNameLabel.text = friendFullName;
    // Забираем фото.
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *friendPhotoPath = [[NSString alloc] initWithFormat:@"%@",self.usersArray[indexPath.row].smallImageURL];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: friendPhotoPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            tableViewCell.userPhotoImageView.image = [UIImage imageWithData: imageData];
        });
    });
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UICollectionViewFlowLayout* flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    BMVvkAllFriendPhotoCollectionView *photosOfThisFriend = [[BMVvkAllFriendPhotoCollectionView alloc]initWithCollectionViewLayout:flowLayout];
    BMVVkUserModel* user = [self.usersArray objectAtIndex:indexPath.row];
    photosOfThisFriend.interestingUser = user;
    photosOfThisFriend.tokenForFriendsController = self.tokenForFriendsController;
    [self.navigationController pushViewController:photosOfThisFriend animated:YES];
}


// animations
- (void)tableView:(UITableView *)tableView willDisplayCell:(VKFriendsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [self.tableView indexPathsForVisibleRows].firstObject.row)
    {
        CALayer *layer = [cell layer];
        layer.position = CGPointMake(CGRectGetWidth(cell.frame), cell.frame.origin.y);
        layer.anchorPoint = CGPointMake(1, 0);
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration = 0.3;
        animation.fromValue = @(M_PI_4*3);
        animation.toValue = @(0);
        animation.removedOnCompletion = YES;
        [layer addAnimation:animation forKey:@"transform.rotation"];
    }
    if (indexPath.row >= [self.tableView indexPathsForVisibleRows].lastObject.row)
    {
        CALayer *layer = [cell layer];
        layer.position = CGPointMake(cell.frame.origin.x, cell.frame.origin.y);
        layer.anchorPoint = CGPointMake(0, 0);
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration = 0.3;
        animation.fromValue = @(M_PI_4*3);
        animation.toValue = @(0);
        animation.removedOnCompletion = YES;
        [layer addAnimation:animation forKey:@"transform.rotation"];
    }
}

@end
