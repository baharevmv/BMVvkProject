//
//  VKFriend+CoreDataProperties.h
//  
//
//  Created by max on 12.02.18.
//
//

#import "VKFriend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VKFriend (CoreDataProperties)

+ (NSFetchRequest<VKFriend *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bigImageURLString;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *imageURLString;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *smallImageURLString;
@property (nullable, nonatomic, copy) NSString *userID;

@end

NS_ASSUME_NONNULL_END
