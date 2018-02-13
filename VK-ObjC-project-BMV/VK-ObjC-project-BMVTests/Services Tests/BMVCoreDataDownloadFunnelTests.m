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

- (void)testObtainModelFriendsWithToken
{
    id mockCoreData = OCMClassMock([BMVCoreDataService class]);
    OCMStub(self.testCoreDataDownloadFunnel.coreDataService).andReturn(mockCoreData);
}


@end
