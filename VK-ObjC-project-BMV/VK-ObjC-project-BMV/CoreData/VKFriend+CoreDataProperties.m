//
//  VKFriend+CoreDataProperties.m
//  
//
//  Created by max on 12.02.18.
//
//

#import "VKFriend+CoreDataProperties.h"

@implementation VKFriend (CoreDataProperties)

+ (NSFetchRequest<VKFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VKFriend"];
}

@dynamic bigImageURLString;
@dynamic firstName;
@dynamic fullName;
@dynamic imageURLString;
@dynamic lastName;
@dynamic smallImageURLString;
@dynamic userID;

@end
