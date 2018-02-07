//
//  BMVCoreDataService.h
//  VK-ObjC-project-BMV
//
//  Created by max on 05.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BMVVkUserModel;


/**
 Сервис для работы с core data
 */
@interface BMVCoreDataService : NSObject


/**
 Инициализирует сервис с контекстом
 @param context - контекст для настрокий сервиса
 @return экземпляр класса BMVCoreDataService
 */
- (instancetype)initWithContext:(NSManagedObjectContext *)context
                 andCoordinator:(NSPersistentStoreCoordinator *)coordinator;


/**
 Обеспечивает получение массива сущностей из core data
 @param className - имя класса сущности
 @return массив сущностей
 */
- (NSArray *)obtainModelArray:(Class)className;


/**
 Сохранение модели в core data
 @param dataFriendModel - модель, котороя сохраняется
 */
- (void)saveFriendModel:(BMVVkUserModel *)dataFriendModel;

/**
 Удаление данных из core data
 @param entity - сущность, которая удаляется
 */
- (void)removeFromCoreData:(NSManagedObject *)entity;


/**
Проверка запускалось ли уже приложение
 */
- (BOOL)isItFirstTimeStarts;

/**
 Обеспечивает работу строки живого поиска.
 @param searchString - строка поиска.
 @return массив сущностей соответствующий поисковому запросу.
 
 */
- (NSArray *)searchingForFriendWithSearchString:(NSString *)searchString;


@end
