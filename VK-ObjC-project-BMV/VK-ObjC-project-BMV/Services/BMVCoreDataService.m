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
#import "AppDelegate.h"


@interface BMVCoreDataService ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@end


@implementation BMVCoreDataService


- (instancetype)initWithContext:(NSManagedObjectContext *)context
                 andCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    self = [super init];
    if (self)
    {
        _context = context;
        _coordinator = coordinator;
    }
    return self;
}


- (NSManagedObjectContext *) context
{
    if (_context)
    {
        return _context;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSPersistentContainer *container = ((AppDelegate *) (application.delegate)).persistentContainer;
    NSManagedObjectContext *context = container.viewContext;
    return context;
}


- (NSArray *)obtainModelArray:(Class)className
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(className)];
    return [self.context executeFetchRequest:fetchRequest error:nil];
}


- (void)saveFriendModel:(NSArray <BMVVkUserModel *> *)vkFriendsModelArray
{
    NSLog(@"Зашли в экземпляр класса saveFriendModel");
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
        friendCoreDataModel.smallImageURL = [NSURL URLWithString:userModel.smallImageURL];
        friendCoreDataModel.imageURL = [NSURL URLWithString:userModel.imageURL];
        friendCoreDataModel.bigImageURL = [NSURL URLWithString:userModel.bigImageURL];
        friendCoreDataModel.userID = [NSString stringWithFormat:@"%@", userModel.userID];
        [self.context save:nil];
    }
}


- (void)removeFromCoreData:(NSManagedObject *)entity
{
    if (!entity)
    {
        return;
    }
    [self.context deleteObject:entity];
    [self.context save:nil];
}


- (BOOL)isItFirstTimeStarts
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL AlreadyStart = [userDefaults boolForKey:@"AlreadyStarts"];
    if (AlreadyStart)
    {
        // если уже запускался - значит не первый запуск.
        return NO;
    }
    else
    {
        // если еще не запускался - запуск первый.
        [userDefaults setBool:YES forKey:@"AlreadyStarts"];
        return YES;
    }
}


- (NSArray *)searchingForFriendWithSearchString:(NSString *)searchString
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"VKFriend"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[c] %@",searchString];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *personsArray = [NSArray new];
    personsArray = nil;
    personsArray = [self.context executeFetchRequest:fetchRequest error:nil];
    return personsArray;
}

@end
