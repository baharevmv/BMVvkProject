//
//  BMVURLRequestGenerator.h
//  VK-ObjC-project-BMV
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Класс для генерации запроса токена от сети Вконтакте.
 */
@interface BMVURLRequestGenerator : NSObject

/**
 Обеспечивает создание URL
 */
- (NSURLRequest *)makingRequest;

@end
