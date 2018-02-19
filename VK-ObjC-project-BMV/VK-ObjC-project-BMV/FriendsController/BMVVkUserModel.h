//
//  UserModel.h
//  VK-ObjC-project-BMV
//
//  Created by max on 14.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VKFriend;


/**
 Модель для работы с данными о пользователях
 */
@interface BMVVkUserModel : NSObject

@property (nonatomic, copy) NSString *userID;               /**< Уникальный идентификатор друга */
@property (nonatomic, copy) NSString *firstName;            /**< Имя Друга */
@property (nonatomic, copy) NSString *lastName;             /**< Фамилия Друга */
@property (nonatomic, copy) NSString *smallImageURLString;  /**< URL c фотографией самого скромного размера для превью */
@property (nonatomic, copy) NSString *imageURLString;       /**< URL c полноразмерной фотографией */
@property (nonatomic, copy) NSString *bigImageURLString;    /**< URL с фотографией в большом разрешении */


/**
 Инициализирует модель с данными
 @param vkFriendModel - сущность, из которой берутся данные для заполнения модели
 @return экземпляр класса BMVVkUserModel
 */
- (instancetype)initWithVKFriend:(VKFriend *)vkFriendModel;

@end
