//
//  BMVVkFriendsViewController.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMVVkTokenModel.h"
@class BMVDownloadDataService;


/**
 Контроллер для отображения списка "друзей"
 */
@interface BMVVkFriendsViewController : UITableViewController

@property(nonatomic, weak) BMVVkTokenModel *tokenForFriendsController;      /**< Токен для работы с API вконтакте */

@end
