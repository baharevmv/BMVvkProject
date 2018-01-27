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

//static NSString *const cellIdentifier = @"cellIdentifier";

@interface VKFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray* friendsArray;
@property (nonatomic, strong) VKFriendsTableViewCellView *tableViewCell;
@property (nonatomic, copy) NSMutableArray <BMVvkUserModel *> *usersArray;


@property (assign, nonatomic) BOOL firstAppearance;

@end

@implementation VKFriendsViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
//        [[VKFriendsViewController alloc ] initToken:self.theToken]
//        [[VKFriendsViewController класс alloc ] initToken:self.theToken]
    }
    return self;
}




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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - API




- (void) getFriendsFromServer:(LocalVKToken *)token {
    [BMVgetFriendsJSONData NetworkWorkingWithFriendsJSON:token completeBlock:^(NSMutableArray <BMVvkUserModel *> *users) {
//        NSLog(@"HERE IS USER - %@",users);
        self.usersArray = users;
//        NSLog(@"%lu", (unsigned long)self.usersArray.count);
    }];
    [self.tableView reloadData];
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
//        [data release];
    });
//    [imageData release];
//    tableViewCell.userPhotoImage.image = [UIImage imageNamed:self.dataSourceForTable[indexPath.row].imageString];
//    tableViewCell.userPhotoImageView.image = [UIImage imageNamed:@"user"];
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    if (indexPath.row == [self.friendsArray count]) {
//        [self getFriendsFromServer];
//    }else{
//        FriendInfoTableViewController *friendsInfo = [FriendInfoTableViewController new];
//        User* user = [self.friendsArray objectAtIndex:indexPath.row];
//        friendsInfo.friendID = user.userID;
//
//        [self.navigationController pushViewController:friendsInfo animated:YES];
//    }
//
//}
//
@end



