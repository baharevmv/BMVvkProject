//
//  VKFriend+CoreDataProperties.m
//  
//
//  Created by max on 05.02.18.
//
//

#import "VKFriend+CoreDataProperties.h"

@implementation VKFriend (CoreDataProperties)

+ (NSFetchRequest<VKFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VKFriend"];
}

@dynamic bigImageURL;
@dynamic firstName;
@dynamic imageURL;
@dynamic lastName;
@dynamic smallImageURL;
@dynamic userID;
@dynamic fullName;

@end
