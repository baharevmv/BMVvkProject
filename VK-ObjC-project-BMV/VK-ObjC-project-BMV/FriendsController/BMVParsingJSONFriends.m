//
//  BMVParsingJSONFriends.m
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVParsingJSONFriends.h"
#import "BMVVkUserModel.h"
#import "BMVDownloadDataService.h"


@implementation BMVParsingJSONFriends


+ (NSArray *)jsonToModel:(NSDictionary *)json
{
    if (!json)
    {
        return nil;
    }
    if (json[@"error"])
    {
        return nil;
    }
    NSArray *usersArray = json[@"response"][@"items"];
    NSMutableArray *readyUsersArray = [NSMutableArray new];
    for (NSDictionary *netModelDictionary in usersArray)
    {
        BMVVkUserModel *typicalFriendModel = [BMVVkUserModel new];
        typicalFriendModel.firstName = netModelDictionary[@"first_name"];
        typicalFriendModel.lastName = netModelDictionary[@"last_name"];
        typicalFriendModel.userID = netModelDictionary[@"id"];
        typicalFriendModel.smallImageURLString = netModelDictionary[@"photo_50"];
        typicalFriendModel.imageURLString = netModelDictionary[@"photo_100"];
        typicalFriendModel.bigImageURLString = netModelDictionary[@"photo_max_orig"];
        [readyUsersArray addObject:typicalFriendModel];
    }
    return [readyUsersArray copy];
}


@end
