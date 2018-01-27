//
//  VKAccessToken+CoreDataProperties.h
//  VK-ObjC-project-BMV
//
//  Created by max on 25.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//
//

#import "VKAccessToken+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VKAccessToken (CoreDataProperties)

+ (NSFetchRequest<VKAccessToken *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *expirationDate;
@property (nullable, nonatomic, copy) NSString *tokenString;
@property (nullable, nonatomic, copy) NSString *userIDString;

@end

NS_ASSUME_NONNULL_END
