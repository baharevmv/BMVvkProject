//
//  BMVvkAllFriendPhotoCollectionView.h
//  VK-ObjC-project-BMV
//
//  Created by max on 28.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMVvkUserModel.h"
#import "LocalVKToken.h"

@interface BMVvkAllFriendPhotoCollectionView : UICollectionViewController

@property (nonatomic, strong) BMVvkUserModel *interestingUser;
@property (nonatomic, strong) LocalVKToken *tokenForFriendsController;

@end
