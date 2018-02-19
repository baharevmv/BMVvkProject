//
//  BMVVkFriendsViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVFriendsViewController.h"
#import "BMVFriendsTableViewCell.h"
#import "BMVVkUserModel.h"
#import "BMVAllFriendsPhotosCollectionView.h"
#import "BMVCoreDataDownloadFunnel.h"
#import "BMVCoreDataService.h"
#import "BMVDownloadDataService.h"
#import "Masonry.h"


static NSString *const BMVCellIdentifier = @"cellIdentifier";


@interface BMVFriendsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, copy) NSArray <BMVVkUserModel *> *usersArray;
@property (nonatomic, strong) BMVCoreDataDownloadFunnel *coreDataDownloadFunnel;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVCoreDataService *coreDataService;
@property (nonatomic, strong) UISearchBar *lifeSearchBar;

@end


@implementation BMVFriendsViewController


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
    [self createUserInterface];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lifeSearchBar.delegate = self;
    [self downloadDataForFriendsTableView];
}


#pragma mark - Working With UI
    
- (void)createUserInterface
{
    [self.tableView registerClass:[BMVFriendsTableViewCell class] forCellReuseIdentifier:BMVCellIdentifier];

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Обновляем..."];
    [refreshControl addTarget:self action:@selector(refreshWithPull:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    self.lifeSearchBar = [UISearchBar new];
    self.lifeSearchBar.returnKeyType = UIReturnKeyDone;
    self.lifeSearchBar.searchBarStyle = UISearchBarStyleProminent;
    self.navigationItem.titleView = self.lifeSearchBar;
    
}


- (void)refreshWithPull:(UIRefreshControl *)refreshControl
{
    [self.coreDataService clearCoreData];
    [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends
                                                  localToken:self.tokenForFriendsController
                                               currentUserID:self.tokenForFriendsController.userIDString
        completeHandler:^(id modelArray) {
            self.usersArray = modelArray;
            BMVCoreDataService *coreDataService = [BMVCoreDataService new];
            [coreDataService saveFriendModel:modelArray];
            [self.tableView reloadData];
        }];
    [refreshControl endRefreshing];
}


#pragma mark - Working With Network

- (void)downloadDataForFriendsTableView
{
    [self.coreDataDownloadFunnel obtainVKFriendsWithLocalToken:self.tokenForFriendsController
     сompleteHandler:^(id dataModel) {
         self.usersArray = dataModel;
         [self.tableView reloadData];
     }];
}


#pragma mark - UITableView Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BMVFriendsTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:BMVCellIdentifier
                                                                               forIndexPath:indexPath];
    // Забираем имя
    NSString *friendFullName = [[NSString alloc] initWithFormat:@"%@ %@",self.usersArray[indexPath.row].firstName,
                                self.usersArray[indexPath.row].lastName];
    tableViewCell.userNameLabel.text = friendFullName;
    // Забираем фото.
    NSString *friendPhotoPath = [[NSString alloc] initWithFormat:@"%@",self.usersArray[indexPath.row].smallImageURLString];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: friendPhotoPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            tableViewCell.userPhotoImageView.image = [UIImage imageWithData: imageData];
        });
    });
    return tableViewCell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.lifeSearchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    BMVAllFriendsPhotosCollectionView *photosOfThisFriend = [[BMVAllFriendsPhotosCollectionView alloc]
                                                                initWithCollectionViewLayout:flowLayout];
    BMVVkUserModel *user = [self.usersArray objectAtIndex:indexPath.row];
    photosOfThisFriend.interestingUser = user;
    photosOfThisFriend.tokenForFriendsController = self.tokenForFriendsController;
    [self.navigationController pushViewController:photosOfThisFriend animated:YES];
}


#pragma mark - Animations

- (void)tableView:(UITableView *)tableView willDisplayCell:(BMVFriendsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
    if ([searchText isEqualToString:@""]) {
        [self downloadDataForFriendsTableView];
    }
    else
    {
        self.usersArray = [self.coreDataService searchingForFriendWithSearchString:searchText];
    }
    [self.tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.lifeSearchBar resignFirstResponder];
}


@end
