//
//  BMVCoreDataDownloadFunnel.m
//  VK-ObjC-project-BMV
//
//  Created by max on 05.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVCoreDataDownloadFacade.h"
#import "BMVDownloadDataService.h"
#import "BMVCoreDataService.h"
#import "BMVVkUserModel.h"
#import "VKFriend+CoreDataClass.h"


@interface BMVCoreDataDownloadFacade()

@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVCoreDataService *coreDataService;

@end


@implementation BMVCoreDataDownloadFacade

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


- (void)obtainVKFriendsWithLocalToken:(BMVVkTokenModel *)token сompleteHandler:(void (^)(id dataModel))completeHandler
{
    BOOL isFirstTime = [self.coreDataService isItFirstTimeStarts];
    if (!isFirstTime)
    {
        NSArray <BMVVkUserModel *> *modelArray = [self.coreDataService obtainModelArray:[VKFriend class]];
        if (completeHandler)
        {
            completeHandler(modelArray);
        }
    }
    else
    {
        [self.downloadDataService downloadDataWithDataTypeString:BMVDownloadDataTypeFriends localToken:token
                                                   currentUserID:token.userIDString offset:nil
            completeHandler:^(id dataModel) {
                [self.coreDataService saveFriendModel:dataModel];
            if (completeHandler)
            {
                completeHandler(dataModel);
            }
        }];
    }
}


@end
