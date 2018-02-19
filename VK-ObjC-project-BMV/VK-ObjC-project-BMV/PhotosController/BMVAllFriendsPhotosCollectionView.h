//
//  BMVAllFriendsPhotosCollectionView.h
//  VK-ObjC-project-BMV
//
//  Created by max on 28.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"


/**
 Контроллер для отображения коллекции с фотографиями конкретного пользователя
 */
@interface BMVAllFriendsPhotosCollectionView : UICollectionViewController


@property (nonatomic, strong) BMVVkUserModel *interestingUser;              /**< Выбранный пользователь */
@property (nonatomic, strong) BMVVkTokenModel *tokenForFriendsController;   /**< Токен для работы с API вконтакте */

@end
