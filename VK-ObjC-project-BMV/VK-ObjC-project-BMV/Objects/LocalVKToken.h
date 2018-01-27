//
//  BMVvkAccessToken.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalVKToken : NSObject

@property (strong, nonatomic) NSString* tokenString;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userIDString;

@end