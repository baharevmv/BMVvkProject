//
//  BMVgetFriendsListData.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVgetPhotosJSONData.h"
#import "LocalVKToken.h"
#import "BMVvkPhotoModel.h"
#import "BMVvkUserModel.h"
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
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
//        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    return self;
}

//"https://api.vk.com/method/photos.getAll?access_token=\%@&owner_id=\(uid)&extended=0"

+ (void)NetworkWorkingWithPhotosJSON:(LocalVKToken *)token /*currentFriend:(BMVvkUserModel *)currentFriend*/ completeBlock:(void(^)(NSMutableArray <BMVvkPhotoModel *> *))completeBlock
{

    NSString *urlGettingPhotosListString = [[NSString alloc] initWithFormat:@"https://api.vk.com/method/photos.getAll?access_token=\%@&owner_id=57630&extended=0&photo_sizes=0&count=200",token.tokenString/*, currentFriend.userID*/];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlGettingPhotosListString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonForParsingContainer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@", jsonForParsingContainer);
        if (!error)
        {
            NSMutableArray *networkModelArray = [NSMutableArray new];
            NSLog(@"ВЫВОЖУ TEMP %@", jsonForParsingContainer);
            [networkModelArray addObjectsFromArray:[BMVParsingPhotosJSONResponse parsingWithJSON:jsonForParsingContainer]];
            NSLog(@"ВЫВОЖУ networkModelArray - %@", networkModelArray);
            completeBlock(networkModelArray);
        }
        else
        {
            NSLog(@"Error!");
        }
    }];
    [dataTask resume];
}

@end
