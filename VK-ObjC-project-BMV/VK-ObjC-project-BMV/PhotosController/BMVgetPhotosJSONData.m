//
//  BMVgetFriendsListData.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVgetPhotosJSONData.h"
#import "BMVVkTokenModel.h"
#import "BMVVkPhotoModel.h"
#import "BMVVkUserModel.h"
#import "BMVParsingPhotosJSONResponse.h"

@interface BMVgetPhotosJSONData()

@property (nonatomic, copy) NSMutableArray <BMVvkPhotoModel *> *networkModelArray;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation BMVgetPhotosJSONData


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _networkModelArray = [NSMutableArray new];
    }
    return self;
}


+ (void)NetworkWorkingWithPhotosJSON:(BMVVkTokenModel *)token currentFriend:(BMVVkUserModel *)currentFriend completeBlock:(void(^)(NSMutableArray <BMVVkPhotoModel *> *))completeBlock
{
    NSLog(@"%@",currentFriend.userID);
    NSString *urlGettingPhotosListString = [[NSString alloc] initWithFormat:@"https://api.vk.com/method/photos.getAll?access_token=\%@&owner_id=%@&extended=0&photo_sizes=0&count=200",token.tokenString, currentFriend.userID];
    NSLog(@"%@", urlGettingPhotosListString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlGettingPhotosListString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonForParsingContainer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!error)
        {
            NSMutableArray *networkModelArray = [NSMutableArray new];
            NSLog(@"ВЫВОЖУ TEMP %@", jsonForParsingContainer);
            [networkModelArray addObjectsFromArray:[BMVParsingPhotosJSONResponse parsingWithJSON:jsonForParsingContainer]];
//            for (NSInteger counter = 0; counter < networkModelArray.count; counter++)
//            {
//                [self downloadPhotoWithSize:networkModelArray[counter] completeBlock:completeBlock];
//            }
            completeBlock(networkModelArray);
        }
        else
        {
            NSLog(@"Error!");
        }
    }];
    [dataTask resume];
}

- (void)downloadPhotoWithSize:(BMVVkUserModel *)userModel completeBlock:(void(^)(BMVVkUserModel *))completeBlock
{
    NSURLRequest *request;
//    if (NetworkDowloadPhotoSizeMinimum == photoSizeType)
//    {
        request = [[NSURLRequest alloc] initWithURL:userModel.smallImageURL];
//    }
//    else
//    {
//        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:networkModel.urlMaxSizePhotoString]];
//    }
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          userModel.previewPhotoImage = [UIImage imageWithData:data];
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completeBlock(userModel);
                                          });
                                      }];
    [dataTask resume];
}

@end
