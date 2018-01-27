//
//  BMVgetFriendsListData.h
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalVKToken.h"
#import "BMVvkUserModel.h"

@interface BMVgetFriendsJSONData : NSObject


+ (void) NetworkWorkingWithFriendsJSON: (LocalVKToken *)token completeBlock:(void(^)(NSMutableArray <BMVvkUserModel *> *))completeBlock;




@end



