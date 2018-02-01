//
//  BMVvkFriendsViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "VKFriendsViewController.h"
#import "VKFriendsTableViewCellView.h"
#import "BMVvkUserModel.h"
#import "BMVgetFriendsJSONData.h"
#import "BMVvkAllFriendPhotoCollectionView.h"

CGFloat const offsetNavBar = 76;
static NSString *const cellIdentifier = @"cellIdentifier";


@interface VKFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *friendsArray;
@property (nonatomic, strong) VKFriendsTableViewCellView *tableViewCell;
@property (nonatomic, copy) NSArray <BMVvkUserModel *> *usersArray;
@property (nonatomic, strong) BMVvkAllFriendPhotoCollectionView *photosOfThisFriend;
@property (assign, nonatomic) BOOL firstAppearance;

@end


@implementation VKFriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFriendsFromServer:self.tokenForFriendsController];
    
    // prepare UI
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VKFriendsTableViewCellView class] forCellReuseIdentifier:@"cellIdentifier"];
    
    self.navigationItem.title = @"Friends";
    self.firstAppearance = YES;
    
    
    //    [self.tableView reloadData];
    
}


#pragma mark - API

- (void) getFriendsFromServer:(LocalVKToken *)token {
    [BMVgetFriendsJSONData NetworkWorkingWithFriendsJSON:token completeBlock:^(NSMutableArray <BMVvkUserModel *> *users) {
        //        NSLog(@"HERE IS USER - %@",users);
        
        self.usersArray = users;
        //        NSLog(@"%lu", (unsigned long)self.usersArray.count);
    }];
//    [self.tableView reloadData];
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return [self.usersArray count] + 1;
    return 980;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VKFriendsTableViewCellView *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    //    [tableView[indexPath] VKFriendsTableViewCellView:prepareForReuse]
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
    BMVvkUserModel* user = [self.usersArray objectAtIndex:indexPath.row];
    photosOfThisFriend.interestingUser = user;
    photosOfThisFriend.tokenForFriendsController = self.tokenForFriendsController;
    [self.navigationController pushViewController:photosOfThisFriend animated:YES];
}

@end
