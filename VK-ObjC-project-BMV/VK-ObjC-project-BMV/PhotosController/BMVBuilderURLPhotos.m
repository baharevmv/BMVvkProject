//
//  BMVBuilderURLPhotos.m
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVBuilderURLPhotos.h"


static NSString *const BMVFirstPartURL = @"https://api.vk.com/method/photos.getAll?access_token=";
static NSString *const BMVSecondPartURL = @"&owner_id=";
static NSString *const BMVThirdPartURL = @"&extended=0&photo_sizes=0&count=200";


@implementation BMVBuilderURLPhotos


+ (NSURL *)urlGetAllPhotosWithToken:(BMVVkTokenModel *)token forCurrentFriendID:(NSString *)currentFriendID
{
    if (!token)
    {
        return nil;
    }
    if (!currentFriendID)
    {
        return nil;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@",BMVFirstPartURL, token.tokenString, BMVSecondPartURL, currentFriendID, BMVThirdPartURL];
    return [NSURL URLWithString:urlString];
}


@end
