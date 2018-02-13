//
//  BMVBuilderURLPhotos.h
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"
#import "BMVVkUserModel.h"


/**
 Класс для построения URL
 */
@interface BMVBuilderURLPhotos : NSObject


/**
 Обеспечивает создание URL
 @param token - токен, необходимый для построения корректного запроса к API вконтакте
 @param currentFriendID - уникальный идентификатор пользователя, фото которого необходимо получить.
 @return необходимый URL
 */
+ (NSURL *)urlGetAllPhotosWithToken:(BMVVkTokenModel *)token forCurrentFriendID:(NSString *)currentFriendID;


@end
