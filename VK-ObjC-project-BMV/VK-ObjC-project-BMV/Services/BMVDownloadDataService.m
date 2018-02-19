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


#pragma mark - Working With VK.com API

- (void)downloadDataWithDataTypeString:(BMVDownloadDataType)dataType
                            localToken:(BMVVkTokenModel *)token currentUserID:(NSString *)userID
                     completeHandler:(void(^)(id))completeHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self buildURLWithType:dataType localToken:token
                                                                  currentUserID:userID]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            id dataModel = [self parsingByType:dataType json:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                completeHandler(dataModel);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
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


#pragma mark - Downloading Photos to iPhone Memory

- (void)downloadAllPhotosToPhotoAlbumWithArray:(NSArray <BMVVkPhotoModel *> *)arrayToDownload
                               completeHandler:(void(^)(id))completeHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    for (BMVVkPhotoModel *photo in arrayToDownload)
    {
        NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
        NSLog(@"%@", originalPhotoPath);
        NSURL *urlToDownload = [NSURL URLWithString:originalPhotoPath];
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlToDownload]];
        SEL _imageDownloaded= @selector(image:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(downloadedImage, self, _imageDownloaded, nil);
    }
    completeHandler(nil);
    });
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        [self tryWriteAgain:image];
    }
}


- (void)tryWriteAgain:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


@end
