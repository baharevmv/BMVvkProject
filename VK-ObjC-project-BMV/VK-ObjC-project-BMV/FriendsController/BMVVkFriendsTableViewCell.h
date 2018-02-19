//
//  BMVVkFriendsTableViewCell.h
//  VK-ObjC-project-BMV
//
//  Created by max on 15.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Ячейка для отображения данных о друге.
 */
@interface BMVVkFriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *userNameLabel;               /**< Фамилия и имя друга*/
@property (nonatomic, strong) UIImageView *userPhotoImageView;      /**< Аватарка друга.*/

@end
