//
//  BMVvkAllFriendPhotoCollectionView.h
//  VK-ObjC-project-BMV
//
//  Created by max on 28.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"


@interface BMVvkAllFriendPhotoCollectionView : UICollectionViewController


@property (nonatomic, strong) BMVVkUserModel *interestingUser;
@property (nonatomic, strong) BMVVkTokenModel *tokenForFriendsController;


@end
