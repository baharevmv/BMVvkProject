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
#import "BMVgetFriendsJSONData.h"
#import "BMVvkAllFriendPhotoCollectionView.h"

CGFloat const offsetNavBar = 76;
static NSString *const cellIdentifier = @"cellIdentifier";


@interface VKFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *friendsArray;
@property (nonatomic, strong) VKFriendsTableViewCell *tableViewCell;
@property (nonatomic, strong) NSMutableArray <BMVVkUserModel *> *usersArray;
@property (nonatomic, strong) BMVvkAllFriendPhotoCollectionView *photosOfThisFriend;
//@property (nonatomic, strong) BMVgetFriendsJSONData *BMVgetFriendsJSONData;
@property (nonatomic, assign) BOOL firstAppearance;


@end


@implementation VKFriendsViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [self getFriendsFromServer:self.tokenForFriendsController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self getFriendsFromServer:self.tokenForFriendsController];
    // prepare UI
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView registerClass:[VKFriendsTableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    self.navigationItem.title = @"Friends";
    self.firstAppearance = YES;
    [self getFriendsFromServer:self.tokenForFriendsController];
    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self getFriendsFromServer:self.tokenForFriendsController];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - API

- (void) getFriendsFromServer:(BMVVkTokenModel *)token
{
    [BMVgetFriendsJSONData networkWorkingWithFriendsJSON:token completeBlock:^(NSMutableArray <BMVVkUserModel *> *users) {
        self.usersArray = users;
        [self.tableView reloadData];
    }];
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
    BMVvkAllFriendPhotoCollectionView *photosOfThisFriend = [[BMVvkAllFriendPhotoCollectionView alloc] initWithCollectionViewLayout:flowLayout];
    BMVVkUserModel* user = [self.usersArray objectAtIndex:indexPath.row];
    photosOfThisFriend.interestingUser = user;
    photosOfThisFriend.tokenForFriendsController = self.tokenForFriendsController;
    [self.navigationController pushViewController:photosOfThisFriend animated:YES];
}

@end
