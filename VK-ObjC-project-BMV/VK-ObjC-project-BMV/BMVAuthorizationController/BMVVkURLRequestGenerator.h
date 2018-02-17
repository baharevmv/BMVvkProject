//
//  BMVVkURLRequestGenerator.h
//  VK-ObjC-project-BMV
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMVVkURLRequestGenerator : NSObject


/**
 Класс для генерации запроса токена от сети Вконтакте.
 */
- (NSURLRequest *) makingRequest;

@end
