//
//  BMVParsingJSONFriendsTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 12.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVParsingJSONFriends.h"
#import "BMVVkUserModel.h"

@interface BMVParsingJSONFriendsTests : XCTestCase

@property (nonatomic, strong) BMVParsingJSONFriends *parsingJSONFriends;

@end

@implementation BMVParsingJSONFriendsTests

- (void)setUp {
    [super setUp];
    self.parsingJSONFriends = ([BMVParsingJSONFriends new]);
}

- (void)tearDown {
    self.parsingJSONFriends = nil;
    [super tearDown];
}

// Условие - В качестве аргумента нет никаких входных данных - nil. Массив - nil

- (void)testJSONToModelNilJSON
{
    NSArray *modelArray = [BMVParsingJSONFriends jsonToModel:nil];
    expect(modelArray).to.beNil();
}

// Условие - Если массив не nil, но в jsonData - пустой массив, то не сформируется модель. На выходе должен быть пустой массив

- (void)testJSONToModelEmptyJSON
{
    NSArray *modelArray = [BMVParsingJSONFriends jsonToModel:@{}];
    expect(modelArray).to.beEmpty();
}

// Условие - Есть данные в JSONData. dictionary. Нужно проверить что в процессе парсинга формируется модель

- (void)testBMVParsingJSONFriendsCorrectOutputFormatType
{
    id arrayOfInputData = OCMClassMock([NSDictionary class]);
    id arrayOfOutputData = [NSArray<BMVVkUserModel *> class];
    NSArray *goingOut = [BMVParsingJSONFriends jsonToModel:arrayOfInputData];
    expect(goingOut).to.beAKindOf(arrayOfOutputData);
}



@end
