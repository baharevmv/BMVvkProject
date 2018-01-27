//
//  VKAccessToken+CoreDataProperties.m
//  VK-ObjC-project-BMV
//
//  Created by max on 25.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//
//

#import "VKAccessToken+CoreDataProperties.h"

@implementation VKAccessToken (CoreDataProperties)

+ (NSFetchRequest<VKAccessToken *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VKAccessToken"];
}

@dynamic expirationDate;
@dynamic tokenString;
@dynamic userIDString;

@end
