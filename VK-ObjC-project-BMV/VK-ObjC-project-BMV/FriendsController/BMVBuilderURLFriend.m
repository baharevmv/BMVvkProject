//
//  BMVBuilderURLFriend.m
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVBuilderURLFriend.h"
#import "BMVVkTokenModel.h"


static NSString *const BMVFirstPartURL = @"https://api.vk.com/method/friends.get?access_token=";
static NSString *const BMVSecondPartURL = @"&fields=first_name,last_name,nickname,domain,photo_50,photo_100,"
                                                                        "photo_max_orig&lang=ru&count=5000&v=5.69";

@implementation BMVBuilderURLFriend


+ (NSURL *)urlWithAllFriendsString:(BMVVkTokenModel *)token
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",BMVFirstPartURL, token.tokenString, BMVSecondPartURL];
    return [NSURL URLWithString:urlString];
}

@end
