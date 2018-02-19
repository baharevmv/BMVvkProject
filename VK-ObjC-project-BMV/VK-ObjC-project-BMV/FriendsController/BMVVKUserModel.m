//
//  UserModel.m
//  VK-ObjC-project-BMV
//
//  Created by max on 14.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVVkUserModel.h"
#import "VKFriend+CoreDataProperties.h"


@implementation BMVVkUserModel


- (instancetype)initWithVKFriend:(VKFriend *)vkFriendModel
{
    self = [super init];
    if (self)
    {
        _firstName = vkFriendModel.firstName;
        _lastName = vkFriendModel.lastName;
        _smallImageURLString = vkFriendModel.smallImageURLString;
        _imageURLString = vkFriendModel.imageURLString;
        _bigImageURLString = vkFriendModel.bigImageURLString;
        _userID = vkFriendModel.userID;
    }
    return self;
}

@end
