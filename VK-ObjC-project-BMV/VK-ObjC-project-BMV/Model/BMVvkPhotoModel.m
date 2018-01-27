//
//  BMVvkPhotoObject.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVvkPhotoModel.h"

@implementation BMVvkPhotoModel


- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.photoID = [responseObject objectForKey:@"pid"];

        NSString* smallUrlString = [responseObject objectForKey:@"src_small"];
        if (smallUrlString) {
            self.previewImageURL = [NSURL URLWithString:smallUrlString];
        }
        
        NSString* mediumUrlString = [responseObject objectForKey:@"src_big"];
        if (mediumUrlString) {
            self.mediumImageURL = [NSURL URLWithString:mediumUrlString];
        }
        
        NSString* bigUrlString = [responseObject objectForKey:@"src_xbig"];
        if (bigUrlString) {
            self.orinalImageURL = [NSURL URLWithString:bigUrlString];
        }
    }
    return self;
}

@end
