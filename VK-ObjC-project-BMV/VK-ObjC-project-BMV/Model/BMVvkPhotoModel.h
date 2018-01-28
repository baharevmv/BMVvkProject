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

@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, strong) NSURL* previewImageURL;
@property (nonatomic, strong) NSURL* mediumImageURL;
@property (nonatomic, strong) NSURL* orinalImageURL;



@end
