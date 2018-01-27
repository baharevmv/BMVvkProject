//
//  BMVParsingJSONRequest.m
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//
//  Сделано. Парсим ловко.

#import "BMVParsingFriendsJSONResponse.h"
#import "UserModel.h"

@implementation BMVParsingFriendsJSONResponse


+ (NSMutableArray <UserModel *> *)parsingWithJSON:(NSDictionary *) json
{
    if (!json)
    {
        return nil;
    }
    NSArray *usersArray = json[@"response"];
    NSMutableArray <UserModel *> *readyUsersArray = [NSMutableArray new];
    
    for (NSDictionary *netModelDictionary in usersArray)
    {
        UserModel *startModel = [UserModel new];
        startModel.firstName = netModelDictionary[@"first_name"];
        startModel.lastName = netModelDictionary[@"last_name"];
        startModel.userID = netModelDictionary[@"user_id"];
        startModel.smallImageURL = netModelDictionary[@"photo_50"];
        startModel.imageURL = netModelDictionary[@"photo_100"];
        startModel.bigImageURL = netModelDictionary[@"photo_max_orig"];
        [readyUsersArray addObject:startModel];
    }
    return readyUsersArray;
}

@end
