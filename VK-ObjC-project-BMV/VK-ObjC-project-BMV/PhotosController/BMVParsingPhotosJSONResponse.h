//
//  BMVParsingJSONRequest.h
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMVvkPhotoModel;

@interface BMVParsingPhotosJSONResponse : NSObject

+ (NSMutableArray <BMVvkPhotoModel *> *)parsingWithJSON:(NSDictionary *) json;

@end
