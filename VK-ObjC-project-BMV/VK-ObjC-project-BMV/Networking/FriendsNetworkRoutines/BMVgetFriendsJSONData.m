//
//  BMVgetFriendsListData.m
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVgetFriendsJSONData.h"
#import "LocalVKToken.h"
#import "UserModel.h"
#import "BMVParsingFriendsJSONResponse.h"

@interface BMVgetFriendsJSONData()

//@property (nonatomic, copy) NSDictionary *jsonWithFriendsInfoDictionary;
@property (nonatomic, copy) NSMutableArray <UserModel *> *networkModelArray;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation BMVgetFriendsJSONData

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


+ (void) NetworkWorksWithJSON:(LocalVKToken *)token
{
    NSString *urlGettingFriendsListString = [[NSString alloc] initWithFormat:@"https://api.vk.com/method/friends.get?access_token=\%@&fields=first_name,last_name,nickname,domain,photo_50,photo_100,photo_max_orig&lang=ru&count=5000&version=5.69",token.tokenString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlGettingFriendsListString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *jsonWithFriendsInfoDictionary = [NSDictionary new];
            jsonWithFriendsInfoDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", jsonWithFriendsInfoDictionary);
        }
        else
        {
            NSLog(@"Error occured!");
        }
    }];
    [dataTask resume];
}



+ (void)NetworkWorkingWithJSON:(LocalVKToken *)token completeBlock:(void(^)(NSMutableArray <UserModel *> *))completeBlock
{

    NSString *urlGettingFriendsListString = [[NSString alloc] initWithFormat:@"https://api.vk.com/method/friends.get?access_token=\%@&fields=first_name,last_name,nickname,domain,photo_50,photo_100,photo_max_orig&lang=ru&count=5000&version=5.69",token.tokenString];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlGettingFriendsListString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlGettingFriendsListString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!error)
        {
            NSMutableArray *networkModelArray = [NSMutableArray new];
            [networkModelArray addObjectsFromArray:[BMVParsingFriendsJSONResponse parsingWithJSON:temp]];
            completeBlock(networkModelArray);
//            for (NSInteger counter = 0; counter < networkModelArray.count; counter++)
//            {
//
//            }
//            NSLog(@"%@", networkModelArray);
        }
        else
        {
            NSLog(@"Error!");
        }
    }];
    [dataTask resume];
}

@end
