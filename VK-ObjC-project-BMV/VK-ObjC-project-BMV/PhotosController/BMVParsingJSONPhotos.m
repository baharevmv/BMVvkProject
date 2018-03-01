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
    NSArray *photoArray = json[@"response"][@"items"];
    for (NSDictionary *netModelDictionary in photoArray)
    {
        if ([netModelDictionary isKindOfClass:[NSDictionary class]])
        {
            BMVVkPhotoModel *typicalPhotoModel = [BMVVkPhotoModel new];
            typicalPhotoModel.photoID = netModelDictionary[@"id"];
            typicalPhotoModel.previewImageURL = netModelDictionary[@"photo_75"];
            typicalPhotoModel.mediumImageURL = netModelDictionary[@"photo_604"];
            typicalPhotoModel.orinalImageURL = netModelDictionary[@"photo_130"];
            [readyPhotosArray addObject:typicalPhotoModel];
        }
    }
    return [readyPhotosArray copy];
}


@end
