//
//  BMVvkFriendsViewController.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalVKToken.h"

@interface VKFriendsViewController : UITableViewController

@property (nonatomic, weak) LocalVKToken *tokenForFriendsController;

@end
