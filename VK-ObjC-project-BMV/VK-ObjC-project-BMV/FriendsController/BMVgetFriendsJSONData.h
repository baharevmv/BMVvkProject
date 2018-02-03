//
//  BMVgetFriendsListData.h
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"
#import "BMVVkUserModel.h"

@interface BMVgetFriendsJSONData : NSObject

// методы с маленькой буквы

+ (void) networkWorkingWithFriendsJSON: (BMVVkTokenModel *)token completeBlock:(void(^)(NSMutableArray <BMVVkUserModel *> *))completeBlock;


//- (void)DownloadPhotoWithSize:(BMVvkUserModel *)bmvVKUser completeBlock:(void(^)(BMVvkUserModel *))completeBlock;
//- (void)downloadPhotoWithSize:(BMVVkUserModel *)userModel completeBlock:(void(^)(BMVVkUserModel *))completeBlock;

@end
