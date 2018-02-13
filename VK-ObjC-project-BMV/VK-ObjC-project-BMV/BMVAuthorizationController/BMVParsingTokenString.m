//
//  BMVParsingTokenString.m
//  VK-ObjC-project-BMV
//
//  Created by max on 08.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVParsingTokenString.h"
#import "BMVVkTokenModel.h"


@implementation BMVParsingTokenString


-(BMVVkTokenModel *)getTokenFromWebViewHandlerWithRequest:(NSURLRequest *)request
{
    BMVVkTokenModel *token = [BMVVkTokenModel new];
    NSString *query = [[request URL] description];
    NSArray *array = [query componentsSeparatedByString:@"#"];
    if (array.count > 1)
    {
        query = [array lastObject];
    }
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString* pair in pairs)
    {
        NSArray *values = [pair componentsSeparatedByString:@"="];
        if ([values count] != 2)
        {
            continue;
        }
        NSString *key = [values firstObject];
        if ([key isEqualToString:@"access_token"])
        {
            token.tokenString = [values lastObject];
        }
        else if ([key isEqualToString:@"expires_in"])
        {
            NSTimeInterval interval = [[values lastObject] doubleValue];
            token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
        }
        else if ([key isEqualToString:@"user_id"])
        {
            token.userIDString = [values lastObject];
        }
    }
    return token;
}

@end
