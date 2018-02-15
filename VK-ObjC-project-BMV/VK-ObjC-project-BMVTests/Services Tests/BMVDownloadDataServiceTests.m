//
//  BMVDownloadDataServiceTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 13.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVDownloadDataService.h"

#import "BMVBuilderURLFriend.h"
#import "BMVBuilderURLPhotos.h"
#import "BMVParsingJSONFriends.h"
#import "BMVParsingJSONPhotos.h"

#import "BMVVkTokenModel.h"

@interface BMVDownloadDataService (SBTTests)

- (NSURL *)buildURLWithType:(BMVDownloadDataType)dataType localToken:(BMVVkTokenModel *)token
              currentUserID:(NSString *)userID;
- (id)parsingByType:(BMVDownloadDataType)dataType json:(id)json;

@end


@interface BMVDownloadDataServiceTests : XCTestCase


@property (nonatomic, strong) BMVDownloadDataService *testDownloadService;

@end

@implementation BMVDownloadDataServiceTests

- (void)setUp {
    [super setUp];
    self.testDownloadService = OCMPartialMock([BMVDownloadDataService new]);
}

- (void)tearDown {
    self.testDownloadService = nil;
    [super tearDown];
}

// Условие - Верно ли формируется URL для типа данных BMVDownloadDataTypeFriends

- (void)testBuildURLWithTypeDownloadDataTypeFriends
{
    NSURL *referenceURL = [NSURL URLWithString:@"www.all_friends.vk.com"];
    NSString *testTokenString = @"123214215215215214124214";
    NSString *testUserIDString = @"123456";
    
    id classMockBuilderURLFriend = OCMClassMock([BMVBuilderURLFriend class]);
    OCMStub([classMockBuilderURLFriend urlForFriendsBuildWithToken:[OCMArg any]]).andReturn(referenceURL);
    
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(testTokenString);
    
    NSURL *url = [self.testDownloadService buildURLWithType:BMVDownloadDataTypeFriends
                                                      localToken:objectMockBMVVkTokenModel currentUserID:testUserIDString];
    expect(url).toNot.beNil();
    expect(url).to.equal(referenceURL);
}

// Условие - Верно ли формируется URL для типа данных BMVDownloadDataTypePhotos

- (void)testBuildURLWithTypeDownloadDataTypePhotos
{
    NSURL *referenceURL = [NSURL URLWithString:@"www.all_photos.vk.com"];
    NSString *testTokenString = @"123214215215215214124214";
    NSString *testUserIDString = @"123456";
    
    id classMockBuilderURLPhotos = OCMClassMock([BMVBuilderURLPhotos class]);
    OCMStub([classMockBuilderURLPhotos urlForAllPhotosWithToken:[OCMArg any] forCurrentFriendID:[OCMArg any]]).andReturn(referenceURL);
    
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(testTokenString);
    
    NSURL *url = [self.testDownloadService buildURLWithType:BMVDownloadDataTypePhotos
                                                 localToken:objectMockBMVVkTokenModel currentUserID:testUserIDString];
    expect(url).toNot.beNil();
    expect(url).to.equal(referenceURL);
}

- (void)testParsingByTypeDownloadDataTypeFriends
{
    NSArray *controlArray = @[@"Ordinary Friends"];
    
    id classMockParsingJSONFriends = OCMClassMock([BMVParsingJSONFriends class]);
    OCMStub([classMockParsingJSONFriends jsonToModel:[OCMArg any]]).andReturn(controlArray);
    
    NSArray *testArray = [self.testDownloadService parsingByType:BMVDownloadDataTypeFriends json:@{}];
    
    expect(testArray).toNot.beNil();
    expect(testArray.count == 1).to.beTruthy();
    expect(testArray[0]).to.equal(@"Ordinary Friends");
}

- (void)testParsingByTypeDownloadDataTypePhotos
{
    NSArray *controlArray = @[@"Brutal Photos"];
    
    id classMockParsingJSONPhotos = OCMClassMock([BMVParsingJSONPhotos class]);
    OCMStub([classMockParsingJSONPhotos jsonToModel:[OCMArg any]]).andReturn(controlArray);
    
    NSArray *testArray = [self.testDownloadService parsingByType:BMVDownloadDataTypePhotos json:@{}];
    
    expect(testArray).toNot.beNil();
    expect(testArray.count == 1).to.beTruthy();
    expect(testArray[0]).to.equal(@"Brutal Photos");
}

@end
