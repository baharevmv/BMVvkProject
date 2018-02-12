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
        BMVVkUserModel *startModel = [BMVVkUserModel new];
        startModel.firstName = netModelDictionary[@"first_name"];
        startModel.lastName = netModelDictionary[@"last_name"];
        startModel.userID = netModelDictionary[@"id"];
        startModel.smallImageURLString = netModelDictionary[@"photo_50"];
        startModel.imageURLString = netModelDictionary[@"photo_100"];
        startModel.bigImageURLString = netModelDictionary[@"photo_max_orig"];
        [readyUsersArray addObject:startModel];
    }
    return [readyUsersArray copy];
}

@end
