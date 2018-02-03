//
//  BMVgetFriendsListData.h
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"
#import "BMVVkUserModel.h"
#import "BMVVkPhotoModel.h"

@interface BMVgetPhotosJSONData : NSObject


+ (void) NetworkWorkingWithPhotosJSON: (BMVVkTokenModel *)token currentFriend:(BMVVkUserModel *)currentFriend completeBlock:(void(^)(NSMutableArray <BMVVkPhotoModel *> *))completeBlock;

@end
