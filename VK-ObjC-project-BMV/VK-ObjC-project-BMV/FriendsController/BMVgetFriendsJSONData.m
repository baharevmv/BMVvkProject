//
//  BMVgetFriendsListData.m
//  VK-ObjC-project-BMV
//
//  Created by max on 22.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVgetFriendsJSONData.h"
#import "BMVVkTokenModel.h"
#import "BMVVkUserModel.h"
#import "BMVParsingFriendsJSONResponse.h"

@interface BMVgetFriendsJSONData()

//@property (nonatomic, copy) NSDictionary *jsonWithFriendsInfoDictionary;
@property (nonatomic, copy) NSMutableArray <BMVVkUserModel *> *networkModelArray;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation BMVgetFriendsJSONData

+ (void)networkWorkingWithFriendsJSON:(BMVVkTokenModel *)token completeBlock:(void(^)(NSMutableArray <BMVVkUserModel *> *))completeBlock
{
    NSString *urlGettingFriendsListString = [[NSString alloc] initWithFormat:@"https://api.vk.com/method/friends.get?access_token=\%@&fields=first_name,last_name,nickname,domain,photo_50,photo_100,photo_max_orig&lang=ru&count=5000&version=5.69",token.tokenString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlGettingFriendsListString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonForParsingContainer = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        if (!error)
        {
            NSMutableArray *networkModelArray = [NSMutableArray new];
            [networkModelArray addObjectsFromArray:[BMVParsingFriendsJSONResponse parsingWithJSON:jsonForParsingContainer]];
            completeBlock(networkModelArray);
        }
        else
        {
            NSLog(@"Error!");
        }
    }];
    [dataTask resume];
}


//- (void)downloadPhotoForUser:(BMVVkUserModel *)userModel completeBlock:(void(^)(BMVVkUserModel *))completeBlock
//{
//    NSURLRequest *request;
//
////    NSLog(@"THIS IS YOUR REQUEST %@", userModel.smallImageURL);
//    request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:userModel.smallImageURL]];
////    NSLog(@"THIS IS YOUR REQUEST %@", request);
//
//
//    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//                                      {
//                                          if (!error){
//                                          userModel.previewPhotoImage = [UIImage imageWithData:data];
//                                          NSLog(@"ФОТКА - %@",userModel.previewPhotoImage);
////                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              completeBlock(userModel);
////                                          });
//                                          }
//                                          else {
//                                          }
//                                      }];
//
//    [dataTask resume];
//}
@end
