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


static NSString *const BMVCellIdentifier = @"cellIdentifier";


@interface VKFriendsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) BMVCoreDataDownloadFunnel *coreDataDownloadFunnel;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVCoreDataService *coreDataService;
@property (nonatomic, strong) BMVVkUserModel *dataFriendModel;
@property (nonatomic, copy) NSArray *friendsArray;
@property (nonatomic, strong) VKFriendsTableViewCell *tableViewCell;
@property (nonatomic, strong) NSArray <BMVVkUserModel *> *usersArray;
@property (nonatomic, strong) BMVvkAllFriendPhotoCollectionView *photosOfThisFriend;
@property (nonatomic, strong) UISearchBar *lifeSearchBar;

@end


@implementation VKFriendsViewController


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _coreDataDownloadFunnel = [BMVCoreDataDownloadFunnel new];
        _downloadDataService = [BMVDownloadDataService new];
        _coreDataService = [BMVCoreDataService new];
    }
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lifeSearchBar.delegate = self;
    [self downloadDataForFriendsTableView];
}

    
- (void)createUI
{
    // PullToRefresh функция
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.frame),
                                                                   (CGRectGetHeight(self.view.frame) - 40))];
    [self.tableView registerClass:[VKFriendsTableViewCell class] forCellReuseIdentifier:BMVCellIdentifier];
    
    self.lifeSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    [self.view addSubview:self.lifeSearchBar];
    
    self.navigationItem.title = @"Friends";
    [self.activityIndicatorView startAnimating];
}


- (void)downloadDataForFriendsTableView
{
    [self.activityIndicatorView startAnimating];
    [self.coreDataDownloadFunnel obtainVKFriendsWithLocalToken:self.tokenForFriendsController
                                               CompleteHandler:^(id dataModel) {
                                                         self.usersArray = dataModel;
                                                         [self.activityIndicatorView stopAnimating];
                                                            [self.tableView reloadData];
                                                     }];
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends queue:nil
                                                  localToken:self.tokenForFriendsController
                                               currentUserID:self.tokenForFriendsController.userIDString
                                             completeHandler:^(id modelArray) {
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
    
    VKFriendsTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:BMVCellIdentifier forIndexPath:indexPath];
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
    BMVvkAllFriendPhotoCollectionView *photosOfThisFriend = [[BMVvkAllFriendPhotoCollectionView alloc]
                                                                initWithCollectionViewLayout:flowLayout];
    BMVVkUserModel* user = [self.usersArray objectAtIndex:indexPath.row];
    photosOfThisFriend.interestingUser = user;
    photosOfThisFriend.tokenForFriendsController = self.tokenForFriendsController;
    [self.navigationController pushViewController:photosOfThisFriend animated:YES];
}


#pragma mark - Animations

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


#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText  isEqual: @""]) {
        [self downloadDataForFriendsTableView];
        [self.tableView reloadData];
    }
    else
    {
        self.usersArray = [self.coreDataService searchingForFriendWithSearchString:searchText];
        [self.tableView reloadData];
    }
}

@end
