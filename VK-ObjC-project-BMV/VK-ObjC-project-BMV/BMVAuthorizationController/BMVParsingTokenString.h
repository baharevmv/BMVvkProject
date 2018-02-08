//
//  BMVParsingTokenString.h
//  VK-ObjC-project-BMV
//
//  Created by max on 08.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"


/**
 Класс для построения URL
 */
@interface BMVParsingTokenString : NSObject


/**
 Обеспечивает парсинг JSON в модель
 @param request - JSON, который парсится в модель
 @return - объект типа токен.
 */
-(BMVVkTokenModel *)getTokenFromWebViewHandlerWithRequest:(NSURLRequest *)request;

@end
