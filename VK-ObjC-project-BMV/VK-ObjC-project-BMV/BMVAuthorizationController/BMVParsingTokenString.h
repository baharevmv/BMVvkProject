//
//  BMVParsingTokenString.h
//  VK-ObjC-project-BMV
//
//  Created by max on 08.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVVkTokenModel.h"

@interface BMVParsingTokenString : NSObject

-(BMVVkTokenModel *)getTokenFromWebViewHandlerWithRequest:(NSURLRequest *)request;

@end
