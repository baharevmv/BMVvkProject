//
//  BMVgetFriendsListData.h
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalVKToken.h"
#import "BMVvkUserModel.h"
#import "BMVvkPhotoModel.h"

@interface BMVgetPhotosJSONData : NSObject


+ (void) NetworkWorkingWithPhotosJSON: (LocalVKToken *)token /*currentFriend:(BMVvkUserModel *)currentFriend*/ completeBlock:(void(^)(NSMutableArray <BMVvkPhotoModel *> *))completeBlock;

@end



