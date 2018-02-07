//
//  BMVDownloadDataService.h
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"
#import "BMVVkPhotoModel.h"


/**
 Сервис для работы с сетью
 */
@interface BMVDownloadDataService : NSObject


/**
 Enum для определения, какой тип данных мы запрашиваем, как должен быть создан URL и как необходимо парсить полученные
 данные из сети.
 */
typedef NS_ENUM(NSUInteger, BMVDownloadDataType)
{
    BMVDownloadDataTypeFriends,
    BMVDownloadDataTypePhotos,
};


/**
 Обеспечивает получение данных из сети
 @param dataType - постоянная из BMVDownloadDataType
 @param queue - очередь, на которой должен быть выполнен completeHandler
 @param token - токен социальной сети Вконтакте, который необходим для построения обращений к API
 @param userID - Строка  с идентификатором пользователя Вконтакте
 @param completeHandler - блок, для выполнения по-окончании загрузки
 */
- (void)downloadDataWithDataTypeString:(BMVDownloadDataType)dataType queue:(dispatch_queue_t)queue
                            localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                       completeHandler:(void(^)(id))completeHandler;


/**
 Обеспечивает получение массива данных из сети
 @param dataType - постоянная из BMVDownloadDataType
 @param token - Токен социальной сети Вконтакте, который необходим для построения обращений к API
 @param userID - Строка  с идентификатором пользователя Вконтакте
 @param completeHandler - блок, который выполняется по окончании загрузки
 */
- (void)downloadGroupWithURLKeyArray:(NSArray *)urlKeyArray downloadDataType:(BMVDownloadDataType)dataType
                          localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                     completeHandler:(void(^)(NSArray *))completeHandler;


/**
 Обеспечивает загрузку фотографий из передаваемого массива
 @param arrayToDownload - массив с элементами типа BMVVkPhotoModel
 */
- (void)downloadAllPhotosToPhotoAlbumWithArray:(NSArray <BMVVkPhotoModel *> *)arrayToDownload completeHandler:(void(^)(id))completeHandler;

@end
