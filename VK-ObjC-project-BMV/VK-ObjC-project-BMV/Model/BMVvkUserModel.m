//
//  UserModel.m
//  VK-ObjC-project-BMV
//
//  Created by max on 14.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVvkUserModel.h"

@implementation BMVvkUserModel

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSNumber *userID = [responseObject objectForKey:@"id"];
        self.userID = userID.stringValue;
        
        NSString* smallUrlString = [responseObject objectForKey:@"photo_50"];
        if (smallUrlString) {
            self.smallImageURL = [NSURL URLWithString:smallUrlString];
        }
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
        NSString* bigUrlString = [responseObject objectForKey:@"photo_max_orig"];
        if (bigUrlString) {
            self.bigImageURL = [NSURL URLWithString:bigUrlString];
        }
    }
    return self;
}


@end


