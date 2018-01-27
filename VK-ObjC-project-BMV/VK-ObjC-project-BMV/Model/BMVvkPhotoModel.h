//
//  BMVvkPhotoObject.h
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKServerObject.h"

@interface BMVvkPhotoModel : VKServerObject

@property (nonatomic) NSString *photoID;
@property (strong, nonatomic) NSURL* previewImageURL;
@property (strong, nonatomic) NSURL* mediumImageURL;
@property (strong, nonatomic) NSURL* orinalImageURL;



@end
