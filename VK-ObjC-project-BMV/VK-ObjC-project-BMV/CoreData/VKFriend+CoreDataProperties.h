//
//  VKFriend+CoreDataProperties.h
//  
//
//  Created by max on 05.02.18.
//
//

#import "VKFriend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VKFriend (CoreDataProperties)

+ (NSFetchRequest<VKFriend *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSURL *bigImageURL;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSURL *imageURL;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSURL *smallImageURL;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *fullName;

@end

NS_ASSUME_NONNULL_END
