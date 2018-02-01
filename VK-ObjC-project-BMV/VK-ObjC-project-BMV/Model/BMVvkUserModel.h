//
//  UserModel.h
//  VK-ObjC-project-BMV
//
//  Created by max on 14.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VKServerObject.h"

@interface BMVvkUserModel : VKServerObject

@property (nonatomic, strong) NSString* firstName;  //copy
@property (nonatomic, strong) NSString* lastName;//copy
@property (nonatomic, strong) NSURL* smallImageURL;
@property (nonatomic, strong) NSURL* imageURL;
@property (nonatomic, strong) NSURL* bigImageURL;
@property (nonatomic, strong) NSString *userID;//copy
//@property (nonatomic, strong) UIImage *previewPhotoImage;

@end

