//
//  BMVvkAccessToken.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Модель для работы с Уникальный кодом для построения запросов - токеном от АПИ вконтакте.
 */
@interface BMVVkTokenModel : NSObject

@property (nonatomic, copy) NSString *tokenString;      /**< непосредственно сам ключ токена */
@property (nonatomic, strong) NSDate *expirationDate;   /**< срок действия токена */
@property (nonatomic, copy) NSString *userIDString;     /**< ID авторизовавшегося пользователя */


@end
