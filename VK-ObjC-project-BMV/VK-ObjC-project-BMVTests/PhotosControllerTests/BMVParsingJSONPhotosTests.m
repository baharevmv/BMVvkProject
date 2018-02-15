//
//  BMVParsingJSONPhotosTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 12.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVParsingJSONPhotos.h"
#import "BMVVkPhotoModel.h"


@interface BMVParsingJSONPhototsTests : XCTestCase

@property (nonatomic, strong) BMVParsingJSONPhotos *parsingJSONPhotos;

@end


@implementation BMVParsingJSONPhototsTests


- (void)setUp {
    [super setUp];
    self.parsingJSONPhotos = ([BMVParsingJSONPhotos new]);
}

- (void)tearDown {
    self.parsingJSONPhotos = nil;
    [super tearDown];
}


// Условие - В качестве аргумента нет никаких входных данных - nil. Массив - nil

- (void)testJSONToModelNilJSON
{
    NSArray *modelArray = [BMVParsingJSONPhotos jsonToModel:nil];
    expect(modelArray).to.beNil();
}


// Условие - Если массив не nil, но в jsonData - пустой массив, то не сформируется модель. На выходе должен быть пустой массив

- (void)testJSONToModelEmptyJSON
{
    NSArray *modelArray = [BMVParsingJSONPhotos jsonToModel:@{}];
    expect(modelArray).to.beEmpty();
}


// Условие - Есть данные в JSONData. dictionary. Нужно проверить что в процессе парсинга формируется модель

- (void)testBMVParsingJSONPhotosCorrectOutputFormatType
{
    id arrayOfInputData = OCMClassMock([NSDictionary class]);
    id arrayOfOutputData = [NSArray<BMVVkPhotoModel *> class];
    NSArray *goingOut = [BMVParsingJSONPhotos jsonToModel:arrayOfInputData];
    expect(goingOut).to.beAKindOf(arrayOfOutputData);
}


// Условие - насколько корректно заполняются поля у модели если JSON правильный

- (void)testJSONErrorHandler
{
    NSDictionary *photosDictionary = [NSDictionary new];
    NSDictionary *jsonDictionary = @{@"error": photosDictionary};
    
    id objectMockBMVVkUserModel = OCMPartialMock([BMVVkPhotoModel new]);
    id classMockBMVVkUserModel = OCMClassMock([BMVVkPhotoModel class]);
    OCMStub([classMockBMVVkUserModel new]).andReturn(objectMockBMVVkUserModel);
    NSArray <BMVVkPhotoModel *> *modelArray = [BMVParsingJSONPhotos jsonToModel:jsonDictionary];
    
    expect(modelArray).to.beNil();
    
//    [classMockBMVVkUserModel stopMocking];
}


// Условие - насколько корректно заполняются поля у модели если JSON неправильный

- (void)testJSONToModelParsing
{
    NSDictionary *photosDictionary = @{@"pid" : @"123456", @"src_small" : @"https://vk.api.com/littlephoto.jpg",
                              @"src_big" : @"https://vk.api.com/photo.jpg", @"src_xbig" : @"https://vk.api.com/bigphoto.jpg"};
    NSDictionary *jsonDictionary = @{@"response": @[@"197", photosDictionary]};

    id objectMockBMVVkPhotoModel = OCMPartialMock([BMVVkPhotoModel new]);
    id classMockBMVVkPhotoModel = OCMClassMock([BMVVkPhotoModel class]);
    OCMStub([classMockBMVVkPhotoModel new]).andReturn(objectMockBMVVkPhotoModel);
    NSArray <BMVVkPhotoModel *> *modelArray = [BMVParsingJSONPhotos jsonToModel:jsonDictionary];

    expect(modelArray).notTo.beNil();
    expect(modelArray.count == 1).to.beTruthy();
    expect(modelArray[0].photoID).to.equal(@"123456");
    expect(modelArray[0].previewImageURL).to.equal(@"https://vk.api.com/littlephoto.jpg");
    expect(modelArray[0].mediumImageURL).to.equal(@"https://vk.api.com/photo.jpg");
    expect(modelArray[0].orinalImageURL).to.equal(@"https://vk.api.com/bigphoto.jpg");

//    [classMockBMVVkPhotoModel stopMocking];
}

// Условие - насколько корректно заполняются поля у модели, если JSON неправильный

- (void)testJSONToModelWhenGotWrongJSON
{
    NSDictionary *photosDictionary = @{@"pid" : @"123456", @"src_small" : @"https://vk.api.com/littlephoto.jpg",
                                       @"src_big" : @"https://vk.api.com/photo.jpg", @"src_xbig" : @"https://vk.api.com/bigphoto.jpg"};
    NSDictionary *jsonDictionary = @{@"response2": @[@"197", photosDictionary]};

    id objectMockBMVVkPhotoModel = OCMPartialMock([BMVVkPhotoModel new]);
    id classMockBMVVkPhotoModel = OCMClassMock([BMVVkPhotoModel class]);
    OCMStub([objectMockBMVVkPhotoModel new]).andReturn(classMockBMVVkPhotoModel);
    NSArray <BMVVkPhotoModel *> *modelArray = [BMVParsingJSONPhotos jsonToModel:jsonDictionary];

    expect(modelArray).notTo.beNil();
    expect(modelArray.count == 0).to.beTruthy();


//    [classMockBMVVkPhotoModel stopMocking];
}

@end

