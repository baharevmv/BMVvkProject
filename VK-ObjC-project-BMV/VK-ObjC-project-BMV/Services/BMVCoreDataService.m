//
//  BMVCoreDataService.m
//  VK-ObjC-project-BMV
//
//  Created by max on 05.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVCoreDataService.h"
#import "VKFriend+CoreDataProperties.h"
#import "BMVVkUserModel.h"


@interface BMVCoreDataService ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end


@implementation BMVCoreDataService


- (NSArray *)obtainModelArray:(Class)className
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(className)];
	return [self.context executeFetchRequest:fetchRequest error:nil];
}


- (NSArray *)searchingForFriendWithSearchString:(NSString *)searchString
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"VKFriend"];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[c] %@",searchString];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
	fetchRequest.sortDescriptors = @[sortDescriptor];
	NSArray *personsArray = [NSArray new];
	personsArray = nil;
	personsArray = [self.context executeFetchRequest:fetchRequest error:nil];
	return personsArray;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
	@synchronized (self) {
		if (_persistentContainer == nil)
		{
			_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"VK_ObjC_project_BMV"];
			[_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription,
																			  NSError *error)
			 {
				 if (error != nil)
				 {
					 NSLog(@"Unresolved error %@, %@", error, error.userInfo);
					 abort();
				 }
			 }];
		}
	}
	return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *context = self.persistentContainer.viewContext;
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}
}


- (void)saveFriendModel:(NSArray <BMVVkUserModel *> *)vkFriendsModelArray
{
	if (!vkFriendsModelArray)
	{
		return;
	}
	for (BMVVkUserModel *userModel in vkFriendsModelArray)
	{
		VKFriend *friendCoreDataModel = [NSEntityDescription
										 insertNewObjectForEntityForName:NSStringFromClass([VKFriend class])
										 inManagedObjectContext:self.context];
		NSString *friendFullName = [[NSString alloc] initWithFormat:@"%@ %@",userModel.firstName, userModel.lastName];
		friendCoreDataModel.fullName = friendFullName;
		friendCoreDataModel.firstName = userModel.firstName;
		friendCoreDataModel.lastName = userModel.lastName;
		friendCoreDataModel.smallImageURLString = userModel.smallImageURLString;
		friendCoreDataModel.imageURLString = userModel.imageURLString;
		friendCoreDataModel.bigImageURLString = userModel.bigImageURLString;
		friendCoreDataModel.userID = [NSString stringWithFormat:@"%@", userModel.userID];
		[self.context save:nil];
	}
}


#pragma mark - Core Data Clearing Support

- (void)removeFromCoreData:(NSManagedObject *)entity
{
	if (!entity)
	{
		return;
	}
	[self.context deleteObject:entity];
	[self.context save:nil];
}

- (void)clearCoreData
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"VKFriend"];
	NSArray *personsArray = [NSArray new];
	personsArray = [self.context executeFetchRequest:fetchRequest error:nil];
	for (NSManagedObject *userModel in personsArray) {
		[self removeFromCoreData:userModel];
	}
}


#pragma mark - CoreData Context&Coordinator

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
	self = [super init];
	if (self)
	{
		_context = context;
	}
	return self;
}


- (NSManagedObjectContext *) context
{
	if (_context)
	{
		return _context;
	}
	NSPersistentContainer *container = self.persistentContainer;
	NSManagedObjectContext *context = container.viewContext;
	return context;
}


#pragma mark - Miscellaneous

- (BOOL)isItFirstTimeStarts
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL alreadyStart = [userDefaults boolForKey:@"AlreadyStarts"];
	if (alreadyStart)
	{
		return NO;
	}
	[userDefaults setBool:YES forKey:@"AlreadyStarts"];
	return YES;
}

@end
