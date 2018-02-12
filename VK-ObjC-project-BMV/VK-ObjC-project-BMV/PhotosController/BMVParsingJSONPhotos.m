//
//  BMVParsingJSONPhotots.m
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVParsingJSONPhotos.h"
#import "BMVVkPhotoModel.h"


@implementation BMVParsingJSONPhotos


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
    NSMutableArray <BMVVkPhotoModel *> *readyPhotosArray = [NSMutableArray new];
    NSArray *photoArray = json[@"response"];
    for (NSDictionary *netModelDictionary in photoArray)
    {
        if ([netModelDictionary isKindOfClass:[NSDictionary class]])
        {
            BMVVkPhotoModel *startModel = [BMVVkPhotoModel new];
            startModel.photoID = netModelDictionary[@"pid"];
            startModel.previewImageURL = netModelDictionary[@"src_small"];
            startModel.mediumImageURL = netModelDictionary[@"src_big"];
            startModel.orinalImageURL = netModelDictionary[@"src_xbig"];
            [readyPhotosArray addObject:startModel];
        }
    }
    return [readyPhotosArray copy];
}

@end
