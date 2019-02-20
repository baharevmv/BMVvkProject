//
//  BMVDownloadDataService.h
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMVVkTokenModel.h"
#import "BMVVkPhotoModel.h"


/**
 Сервис для работы с сетью
 */
@interface BMVDownloadDataService : NSObject


/**
 Enum для определения, какой тип данных мы запрашиваем, от этого зависит как должен быть создан URL и как необходимо
 парсить полученные из сети данные.
 */
typedef NS_ENUM(NSUInteger, BMVDownloadDataType)
{
	BMVDownloadDataTypeFriends,
	BMVDownloadDataTypePhotos,
};


/**
 Обеспечивает получение данных из сети
 @param dataType - постоянная из BMVDownloadDataType
 @param token - токен социальной сети Вконтакте, который необходим для построения обращений к API
 @param userID - строка с идентификатором пользователя Вконтакте
 @param offset - смещение, необходимое для выборки определенного подмножества
 @param completeHandler - блок, для выполнения по-окончании загрузки
 
 */
- (void)downloadDataWithDataTypeString:(BMVDownloadDataType)dataType
							localToken:(BMVVkTokenModel *)token
						 currentUserID:(NSString *)userID
								offset:(NSNumber *)offset
					   completeHandler:(void(^)(id))completeHandler;


/**
 Обеспечивает загрузку фотографий из передаваемого массива
 @param arrayToDownload - массив с элементами типа BMVVkPhotoModel
 */
- (void)downloadAllPhotosToPhotoAlbumWithArray:(NSArray <BMVVkPhotoModel *> *)arrayToDownload
							   completeHandler:(void(^)(id))completeHandler;


@end
