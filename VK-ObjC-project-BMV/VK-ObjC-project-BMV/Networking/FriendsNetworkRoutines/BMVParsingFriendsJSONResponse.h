//
//  BMVParsingJSONRequest.h
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface BMVParsingFriendsJSONResponse : NSObject

+ (NSMutableArray <UserModel *> *)parsingWithJSON:(NSDictionary *) json;

@end
