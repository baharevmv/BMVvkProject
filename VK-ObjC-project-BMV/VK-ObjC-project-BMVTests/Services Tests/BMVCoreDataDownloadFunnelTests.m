//
//  BMVCoreDataDownloadFunnelTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 13.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta.h>
#import <OCMock.h>
#import "BMVCoreDataDownloadFunnel.h"
#import "BMVCoreDataService.h"
#import "BMVDownloadDataService.h"
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"

@interface BMVCoreDataDownloadFunnel (BMVTests)

@property (nonatomic, strong) BMVCoreDataService *coreDataService;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;

@end



@interface BMVCoreDataDownloadFunnelTests : XCTestCase

@property (nonatomic, strong) BMVCoreDataDownloadFunnel *testCoreDataDownloadFunnel;

@end

@implementation BMVCoreDataDownloadFunnelTests

- (void)setUp
{
    [super setUp];
    self.testCoreDataDownloadFunnel = OCMPartialMock([BMVCoreDataDownloadFunnel new]);
}

- (void)tearDown
{
    [super tearDown];
    self.testCoreDataDownloadFunnel = nil;
}

- (void)testObtainModelFriendsWithTokenIfItsFirstTime
{
    id mockCoreData = OCMClassMock([BMVCoreDataService class]);
    OCMStub(self.testCoreDataDownloadFunnel.coreDataService).andReturn(mockCoreData);
    OCMStub([mockCoreData obtainModelArray:nil]).andReturn(@[]);
    OCMStub([mockCoreData isItFirstTimeStarts]).andReturn(YES);
    
    id objectMockDataModel = OCMPartialMock([BMVVkUserModel new]);
    id classMockDataModel = OCMClassMock([BMVVkUserModel class]);
    
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(@"12345678");
    
    OCMStub([[classMockDataModel alloc] initWithVKFriend:nil]).andReturn(objectMockDataModel);
    void(^completeHandler)(BMVVkUserModel *dataModelArray) = ^(BMVVkUserModel *dataModelArray){};
    
    [self.testCoreDataDownloadFunnel obtainVKFriendsWithLocalToken:(objectMockBMVVkTokenModel) сompleteHandler:completeHandler];
    
    expect(objectMockDataModel).notTo.beNil;
    expect(completeHandler).notTo.raiseAny();
}


- (void) testObtainVKFriendsWithLocalTokenIfItIsNotFirstTime
{
    id mockCoreData = OCMClassMock([BMVCoreDataService class]);
    OCMStub(self.testCoreDataDownloadFunnel.coreDataService).andReturn(mockCoreData);
    OCMStub([mockCoreData obtainModelArray:nil]).andReturn(@[]);
    OCMStub([mockCoreData isItFirstTimeStarts]).andReturn(NO);
    
    id objectMockDataModel = OCMPartialMock([BMVVkUserModel new]);
    id mockDownloadData = OCMClassMock([BMVDownloadDataService class]);
    
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(@"12345678");

    OCMStub(self.testCoreDataDownloadFunnel.downloadDataService).andReturn(mockDownloadData);
    
    OCMExpect([[mockDownloadData ignoringNonObjectArgs] downloadDataWithDataTypeString:BMVDownloadDataTypeFriends queue:nil localToken:objectMockBMVVkTokenModel currentUserID:@"3213211" completeHandler:([OCMArg invokeBlockWithArgs:objectMockDataModel, nil])]);
    
    void(^completeHandler)(BMVVkUserModel *friendDataModel) = ^(BMVVkUserModel *friendDataModel){};
    
    [self.testCoreDataDownloadFunnel obtainVKFriendsWithLocalToken:(objectMockBMVVkTokenModel) сompleteHandler:completeHandler];

    expect(completeHandler).notTo.raiseAny();
//    OCMVerifyAll(mockDownloadData);
}

@end
