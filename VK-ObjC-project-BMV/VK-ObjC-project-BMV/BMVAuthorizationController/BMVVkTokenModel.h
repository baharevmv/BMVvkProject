//
//  BMVvkAccessToken.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "VKServerObject.h"

@interface BMVVkTokenModel : NSObject

@property (nonatomic, copy) NSString* tokenString;
@property (nonatomic, strong) NSDate* expirationDate;
@property (nonatomic, copy) NSString* userIDString;

@end
