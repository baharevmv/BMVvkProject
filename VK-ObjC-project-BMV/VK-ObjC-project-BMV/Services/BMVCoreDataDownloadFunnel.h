//
//  BMVCoreDataDownloadFunnel.h
//  VK-ObjC-project-BMV
//
//  Created by max on 05.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMVDownloadDataService;
@class BMVCoreDataService;
@class BMVVkUserModel;
@class BMVVkTokenModel;


/**
 Класс для слияния функционала сервисов core data и download data
 */
@interface BMVCoreDataDownloadFunnel : NSObject


/**
 Токен необходимый для обращения к API вконтакте.
 */
@property (nonatomic, weak) BMVVkTokenModel *tokenForFriendsController;


/**
 Обеспечивает получение модели BMVDataGraphModel
 @param completeHandler - блок, который выполняется по окончании метода
 block parameters:
 dataModel - запрашиваемая модель данных
 */
- (void)obtainVKFriendsWithLocalToken:(BMVVkTokenModel *)token сompleteHandler:(void (^)(id dataModel))completeHandler;


@end
