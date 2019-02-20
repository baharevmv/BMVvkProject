//
//  BMVvkPhotoObject.h
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Модель для работы с данными о пользователях
 */
@interface BMVVkPhotoModel : NSObject

@property (nonatomic, copy) NSString *photoID;			/**< Уникальный идентифиактор фото */
@property (nonatomic, strong) NSURL *previewImageURL;	/**< URL с фотографией для превью */
@property (nonatomic, strong) NSURL *mediumImageURL;	/**< URL с фотографией для закачки */
@property (nonatomic, strong) NSURL *orinalImageURL;	/**< URL с фотографией для просмотра */

@end
