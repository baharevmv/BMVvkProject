//
//  BMVCoreDataDownloadFunnel.m
//  VK-ObjC-project-BMV
//
//  Created by max on 05.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVCoreDataDownloadFunnel.h"
#import "BMVDownloadDataService.h"
#import "BMVCoreDataService.h"
#import "BMVVkUserModel.h"
#import "VKFriend+CoreDataClass.h"


@interface BMVCoreDataDownloadFunnel()

@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVCoreDataService *coreDataService;

@end

@implementation BMVCoreDataDownloadFunnel


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _downloadDataService = [BMVDownloadDataService new];
        _coreDataService = [BMVCoreDataService new];
    }
    return self;
}


- (void)obtainVKFriendsWithLocalToken:(BMVVkTokenModel *)token CompleteHandler:(void (^)(id dataModel))completeHandler
{
    NSLog(@"Вошли в obtainVKFriendsWithPredicateString");
    BOOL isFirstTime = [self.coreDataService isItFirstTimeStarts];
    if (!isFirstTime)
    {
        // Не первый запуск
        // тянем из CoreData
        NSArray <BMVVkUserModel *> *modelArray = [self.coreDataService obtainModelArray:[VKFriend class]];
        completeHandler(modelArray);
    }
    else
    {
        // Запуск первый
        // Загружаем в таблицу и CoreData из сети.
        [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends queue:nil localToken:token currentUserID:token.userIDString
        completeHandler:^(id dataModel) {
            [self.coreDataService saveFriendModel:dataModel];
            completeHandler(dataModel);
        }];
    }
}


@end
