//
//  BMVgetFriendsListData.h
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalVKToken.h"
#import "UserModel.h"

@interface BMVgetFriendsJSONData : NSObject


+ (void) NetworkWorksWithJSON: (LocalVKToken *)token;


+ (void) NetworkWorkingWithJSON: (LocalVKToken *)token completeBlock:(void(^)(NSMutableArray <UserModel *> *))completeBlock;




@end



