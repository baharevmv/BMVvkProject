//
//  BMVParsingJSONPhotots.h
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import <Foundation/Foundation.h>
@class BMVVkPhotoModel;


/**
 Класс для получения модели BMVVkUserModel из JSON
 */
@interface BMVParsingJSONPhotos : NSObject


/**
 Обеспечивает парсинг JSON в модель
 @param json - JSON, который парсится в модель
 @return массив моделей
 */
+ (NSArray *)jsonToModel:(NSDictionary *)json;

@end
