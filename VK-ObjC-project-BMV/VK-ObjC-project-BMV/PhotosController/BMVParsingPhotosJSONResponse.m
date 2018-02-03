//
//  BMVParsingJSONRequest.m
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVParsingPhotosJSONResponse.h"
#import "BMVVkPhotoModel.h"

@implementation BMVParsingPhotosJSONResponse


+ (NSMutableArray <BMVVkPhotoModel *> *)parsingWithJSON:(NSDictionary *) json
{
    if (!json)
    {
        return nil;
    }
    NSArray *photoArray = json[@"response"];
    NSMutableArray <BMVVkPhotoModel *> *readyPhotosArray = [NSMutableArray new];
    
    for (NSDictionary *netModelDictionary in photoArray)
    {
        if ([netModelDictionary isKindOfClass:[NSDictionary class]])
        {
            BMVVkPhotoModel *startModel = [BMVVkPhotoModel new];
            NSLog(@"%@", netModelDictionary);
            startModel.photoID = netModelDictionary[@"pid"];
            startModel.previewImageURL = netModelDictionary[@"src_small"];
            startModel.mediumImageURL = netModelDictionary[@"src_big"];
            startModel.orinalImageURL = netModelDictionary[@"src_xbig"];
            [readyPhotosArray addObject:startModel];
        }
    }
    return readyPhotosArray;
}

@end
