//
//  BMVBuilderURLFriend.h
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"


/**
 Класс для построения URL
 */
@interface BMVBuilderURLFriend : NSObject


/**
 Обеспечивает создание URL
 @param token - токен социальной сети Вконтакте, который необходим для построения обращений к API
 @return необходимый URL
 */
+ (NSURL *)urlForFriendsBuildWithToken:(BMVVkTokenModel *)token;

@end
