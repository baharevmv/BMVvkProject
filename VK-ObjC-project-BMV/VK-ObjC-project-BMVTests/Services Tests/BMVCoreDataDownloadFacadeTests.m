//
//  BMVCoreDataDownloadFacadeTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 13.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta.h>
#import <OCMock.h>
#import "BMVCoreDataDownloadFacade.h"
#import "BMVCoreDataService.h"
#import "BMVDownloadDataService.h"
#import "BMVVkUserModel.h"
#import "BMVVkTokenModel.h"

@interface BMVCoreDataDownloadFacade (BMVTests)

@property (nonatomic, strong) BMVCoreDataService *coreDataService;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;

@end


@interface BMVCoreDataDownloadFacadeTests : XCTestCase

@property (nonatomic, strong) BMVCoreDataDownloadFacade *testCoreDataDownloadFacade;

@end


@implementation BMVCoreDataDownloadFacadeTests

- (void)setUp
{
	[super setUp];
	self.testCoreDataDownloadFacade = OCMPartialMock([BMVCoreDataDownloadFacade new]);
}

- (void)tearDown
{
	[super tearDown];
	self.testCoreDataDownloadFacade = nil;
}


// Условие - Получаем данные о "друзьях" не в первый раз.

- (void)testObtainModelFriendsWithTokenIfItIsNotFirstTime
{
	id mockCoreData = OCMClassMock([BMVCoreDataService class]);
	OCMStub(self.testCoreDataDownloadFacade.coreDataService).andReturn(mockCoreData);
	OCMStub([mockCoreData obtainModelArray:nil]).andReturn(@[]);
	OCMStub([mockCoreData isItFirstTimeStarts]).andReturn(YES);
	
	id objectMockDataModel = OCMPartialMock([BMVVkUserModel new]);
	id classMockDataModel = OCMClassMock([BMVVkUserModel class]);
	
	id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
	OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(@"12345678");
	
	OCMStub([[classMockDataModel alloc] initWithVKFriend:nil]).andReturn(objectMockDataModel);
	void(^completeHandler)(BMVVkUserModel *dataModelArray) = ^(BMVVkUserModel *dataModelArray){};
	
	[self.testCoreDataDownloadFacade obtainVKFriendsWithLocalToken:(objectMockBMVVkTokenModel) сompleteHandler:completeHandler];
	
	expect(objectMockDataModel).notTo.beNil;
	expect(completeHandler).notTo.raiseAny();
	
	[mockCoreData stopMocking];
	[classMockDataModel stopMocking];
}


// Условие - Получаем данные о "друзьях" в первый раз.

- (void) testObtainVKFriendsWithLocalTokenIfItsFirstTime
{
	id mockCoreData = OCMClassMock([BMVCoreDataService class]);
	OCMStub(self.testCoreDataDownloadFacade.coreDataService).andReturn(mockCoreData);
	OCMStub([mockCoreData obtainModelArray:nil]).andReturn(@[]);
	OCMStub([mockCoreData isItFirstTimeStarts]).andReturn(NO);
	
	id objectMockDataModel = OCMPartialMock([BMVVkUserModel new]);
	id mockDownloadData = OCMClassMock([BMVDownloadDataService class]);
	
	id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
	OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(@"12345678");
	
	OCMStub(self.testCoreDataDownloadFacade.downloadDataService).andReturn(mockDownloadData);
	
	OCMExpect([[mockDownloadData ignoringNonObjectArgs] downloadDataWithDataTypeString:BMVDownloadDataTypeFriends localToken:objectMockBMVVkTokenModel currentUserID:@"3213211" offset:nil completeHandler:([OCMArg invokeBlockWithArgs:objectMockDataModel, nil])]);
	
	void(^completeHandler)(BMVVkUserModel *friendDataModel) = ^(BMVVkUserModel *friendDataModel){};
	
	[self.testCoreDataDownloadFacade obtainVKFriendsWithLocalToken:(objectMockBMVVkTokenModel) сompleteHandler:completeHandler];
	
	expect(completeHandler).notTo.raiseAny();
}

@end
