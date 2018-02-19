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


// Условие - Если в заголовке JSON кодовое значение "error"

- (void)testJSONErrorHandler
{
    NSArray *usersArray = [NSArray new];
    NSDictionary *jsonDictionary = @{@"error": usersArray};
    
    id objectMockBMVVkUserModel = OCMPartialMock([BMVVkUserModel new]);
    id classMockBMVVkUserModel = OCMClassMock([BMVVkUserModel class]);
    OCMStub([classMockBMVVkUserModel new]).andReturn(objectMockBMVVkUserModel);
    NSArray <BMVVkUserModel *> *modelArray = [BMVParsingJSONFriends jsonToModel:jsonDictionary];
    
    expect(modelArray).to.beNil();
}


// Условие - насколько корректно заполняются поля у модели если JSON правильный

- (void)testJSONToModelParsing
{
    NSArray *usersArray = @[@{@"id" : @"123456", @"first_name" : @"Александр", @"last_name" : @"Александров", @"photo_50" : @"https://vk.api.com/littlephoto.jpg",
                              @"photo_100" : @"https://vk.api.com/photo.jpg", @"photo_max_orig" : @"https://vk.api.com/bigphoto.jpg"}];
    NSDictionary *jsonDictionary = @{@"response": @{@"count" : @"991", @"items" : usersArray}};
    
    id objectMockBMVVkUserModel = OCMPartialMock([BMVVkUserModel new]);
    id classMockBMVVkUserModel = OCMClassMock([BMVVkUserModel class]);
    OCMStub([classMockBMVVkUserModel new]).andReturn(objectMockBMVVkUserModel);
    NSArray <BMVVkUserModel *> *modelArray = [BMVParsingJSONFriends jsonToModel:jsonDictionary];
    
    expect(modelArray).notTo.beNil();
    expect(modelArray.count == 1).to.beTruthy();
    expect(modelArray[0].firstName).to.equal(@"Александр");
    expect(modelArray[0].lastName).to.equal(@"Александров");
    expect(modelArray[0].userID).to.equal(@"123456");
    expect(modelArray[0].smallImageURLString).to.equal(@"https://vk.api.com/littlephoto.jpg");
    expect(modelArray[0].imageURLString).to.equal(@"https://vk.api.com/photo.jpg");
    expect(modelArray[0].bigImageURLString).to.equal(@"https://vk.api.com/bigphoto.jpg");
}


// Условие - насколько корректно заполняются поля у модели, если JSON неправильный

- (void)testJSONToModelButGotWrongJSON
{
    NSArray *usersArray = @[@{@"Id" : @"123456", @"firstname" : @"Александр", @"lat_name" : @"Александров", @"photo_0" : @"https://vk.api.com/littlephoto.jpg",
                              @"ph0to_100" : @"https://vk.api.com/photo.jpg", @"photo_man_orig" : @"https://vk.api.com/bigphoto.jpg"}];
    NSDictionary *jsonDictionary = @{@"response": @{@"count" : @"991", @"items" : usersArray}};
    
    id objectMockBMVVkUserModel = OCMPartialMock([BMVVkUserModel new]);
    id classMockBMVVkUserModel = OCMClassMock([BMVVkUserModel class]);
    OCMStub([classMockBMVVkUserModel new]).andReturn(objectMockBMVVkUserModel);
    
    NSArray <BMVVkUserModel *> *modelArray = [BMVParsingJSONFriends jsonToModel:jsonDictionary];
    expect(modelArray).notTo.beNil();
    expect(modelArray.count == 1).to.beTruthy();
    expect(modelArray[0].firstName).to.beNil();
    expect(modelArray[0].lastName).to.beNil();
    expect(modelArray[0].userID).to.beNil();
    expect(modelArray[0].smallImageURLString).to.beNil();
    expect(modelArray[0].imageURLString).to.beNil();
    expect(modelArray[0].bigImageURLString).to.beNil();
}

@end
