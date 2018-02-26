//
//  BMVFriendsViewController.h
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
@interface BMVFriendsViewController : UITableViewController

@property(nonatomic, strong) BMVVkTokenModel *tokenForFriendsController;      /**< Токен для работы с API вконтакте */

@end
