//
//  UserModel.h
//  VK-ObjC-project-BMV
//
//  Created by max on 14.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKServerObject.h"

@interface UserModel : VKServerObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* smallImageURL;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* bigImageURL;
@property (strong, nonatomic) NSString *userID;

@end

