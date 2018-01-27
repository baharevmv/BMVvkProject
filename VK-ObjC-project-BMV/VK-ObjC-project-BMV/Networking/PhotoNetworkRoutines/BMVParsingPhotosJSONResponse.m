//
//  BMVParsingJSONRequest.m
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//
//  Сделано. Парсим ловко.

#import "BMVParsingPhotosJSONResponse.h"
#import "BMVvkPhotoModel.h"

@implementation BMVParsingPhotosJSONResponse


+ (NSMutableArray <BMVvkPhotoModel *> *)parsingWithJSON:(NSDictionary *) json
{
    if (!json)
    {
        return nil;
    }
    NSArray *photoArray = json[@"response"];
    NSMutableArray <BMVvkPhotoModel *> *readyPhotosArray = [NSMutableArray new];
    
    for (NSDictionary *netModelDictionary in photoArray)
    {
        if ([netModelDictionary isKindOfClass:[NSDictionary class]])
        {
            BMVvkPhotoModel *startModel = [BMVvkPhotoModel new];
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
