//
//  BMVDownloadDataService.m
//  VK-ObjC-project-BMV
//
//  Created by max on 04.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVDownloadDataService.h"
#import "BMVBuilderURLFriend.h"
#import "BMVBuilderURLPhotos.h"

#import "BMVParsingJSONFriends.h"
#import "BMVParsingJSONPhotots.h"


@interface BMVDownloadDataService ()

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation BMVDownloadDataService

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        _session = session;
    }
    return self;
}


// НУЖНО НАПИСАТЬ РЕАЛИЗАЦИЮ.

- (void)downloadDataWithDataTypeString:(BMVDownloadDataType)dataType queue:(dispatch_queue_t)queue localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                     completeHandler:(void(^)(id))completeHandler
{
    dispatch_queue_t queue_t = dispatch_get_main_queue();
    if (queue)
    {
        queue_t = queue;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[self buildURLByType:dataType localToken:token currentUserID:userID]];
    NSLog(@"Запрос выглядит так -  %@", request);
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         if (data)
                                                         {
                                                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                             id dataModel = [self parsingByType:dataType json:json];
                                                             dispatch_async(queue_t, ^{
                                                                 completeHandler(dataModel);
                                                             });
                                                         }
                                                         else
                                                         {
                                                             dispatch_async(queue_t, ^{
                                                                 completeHandler(nil);
                                                             });
                                                         }
                                                     }];
    [dataTask resume];
}

- (void)downloadGroupWithURLKeyArray:(NSArray *)urlKeyArray downloadDataType:(BMVDownloadDataType)dataType localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                     completeHandler:(void(^)(NSArray *))completeHandler
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    __block NSMutableArray *modelArray = [NSMutableArray new];
    dispatch_async(queue, ^{
        dispatch_group_t dispatchGroup = dispatch_group_create();
            dispatch_group_enter(dispatchGroup);
            [self downloadDataWithDataTypeString:dataType queue:queue localToken:token currentUserID:userID
                               completeHandler:^(id dataModel) {
                                   if (dataModel)
                                   {
                                       [modelArray addObject:dataModel];
                                   }
                                   dispatch_group_leave(dispatchGroup);
                               }];
        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            completeHandler([modelArray copy]);
        });
    });
}


// НАПИШИ РЕАЛИЗАЦИЮ. "РЕАЛИЗАЦИЮ". ХА-ХА ОЧЕНЬ СМЕШНО.




- (NSURL *)buildURLByType:(BMVDownloadDataType)dataType localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
{
    NSURL *url;
    switch (dataType)
    {
        case BMVDownloadDataTypeFriends:
        {
            url = [BMVBuilderURLFriend urlWithAllFriendsString:token];
            
            NSLog(@"%@",url);
            break;
        }
        case BMVDownloadDataTypePhotos:
        {
            url = [BMVBuilderURLPhotos urlWithAllFreindsPhotosString:token currentFriendID:userID];
            break;
        }
    }
    return url;
}


- (id)parsingByType:(BMVDownloadDataType)dataType json:(NSDictionary *)json
{
    id dataModel;
    switch (dataType)
    {
        case BMVDownloadDataTypeFriends:
        {
            dataModel = [BMVParsingJSONFriends jsonToModel:json];
            break;
        }
        case BMVDownloadDataTypePhotos:
        {
            dataModel = [BMVParsingJSONPhotots jsonToModel:json];
            break;
        }
    }
    return dataModel;
}

@end
