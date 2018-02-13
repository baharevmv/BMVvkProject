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
#import "BMVParsingJSONPhotos.h"


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



- (void)downloadDataWithDataTypeString:(BMVDownloadDataType)dataType queue:(dispatch_queue_t)queue
                            localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                     completeHandler:(void(^)(id))completeHandler
{
    NSLog(@"Зашли в экземпляр класса downloadDataWithDataTypeString");
    dispatch_queue_t queue_t = dispatch_get_main_queue();
    if (queue)
    {
        queue_t = queue;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[self buildURLWithType:dataType
                                                                   localToken:token currentUserID:userID]];
    NSLog(@"Запрос выглядит так -  %@", request);
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data,
                                                                         NSURLResponse *response,
                                                                         NSError *error){
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


- (NSURL *)buildURLWithType:(BMVDownloadDataType)dataType localToken:(BMVVkTokenModel *)token
            currentUserID:(NSString *)userID
{
    NSURL *url;
    switch (dataType)
    {
        case BMVDownloadDataTypeFriends:
        {
            url = [BMVBuilderURLFriend urlForFriendsBuildWithToken:token];
            break;
        }
        case BMVDownloadDataTypePhotos:
        {
            url = [BMVBuilderURLPhotos urlForAllPhotosWithToken:token forCurrentFriendID:userID];
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
            dataModel = [BMVParsingJSONPhotos jsonToModel:json];
            break;
        }
    }
    return dataModel;
}


- (void)downloadAllPhotosToPhotoAlbumWithArray:(NSArray <BMVVkPhotoModel *> *)arrayToDownload completeHandler:(void(^)(id))completeHandler
{
    for (BMVVkPhotoModel *photo in arrayToDownload)
    {
        NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
            NSLog(@"%@", originalPhotoPath);
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:originalPhotoPath]]];
            SEL _imageDownloaded= @selector(image:didFinishSavingWithError:contextInfo:);
            UIImageWriteToSavedPhotosAlbum(downloadedImage, self, _imageDownloaded, nil);
    }
    completeHandler(nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        return;
    }
    [self tryWriteAgain:image];
}

- (void)tryWriteAgain:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


//- (void)downloadAllPhotosWithArray:(NSArray *)arrayWithModel
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        {
//            [self downloadAllPhotosToPhotoAlbumWithArray:arrayWithModel completeHandler:^(id any) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.activityView stopAnimating];
//                    [self.loadingView removeFromSuperview];
//                    NSLog(@"Задание на загрузку выполнено");
//                });
//            }];
//        }
//    });
//}


@end
