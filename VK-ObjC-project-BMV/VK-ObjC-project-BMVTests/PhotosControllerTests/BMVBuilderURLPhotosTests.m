//
//  BMVBuilderURLPhotosTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 12.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVBuilderURLPhotos.h"
#import "BMVVkTokenModel.h"

static NSString *const BMVFirstPartURL = @"https://api.vk.com/method/photos.getAll?access_token=";
static NSString *const BMVSecondPartURL = @"&owner_id=";
static NSString *const BMVThirdPartURL = @"&extended=0&photo_sizes=0&count=200";
static NSString *testTokenString = @"123214215215215214124214";


@interface BMVBuilderURLPhotosTests : XCTestCase

@end

@implementation BMVBuilderURLPhotosTests


// Условие - Вместо Токена в класс передали nil

- (void) testURLBuilderWithNilToken
{
    NSURL *url = [BMVBuilderURLPhotos urlForAllPhotosWithToken:nil forCurrentFriendID:@"123456"];
    expect(url).to.beNil();
}


// Условие - Вместо ID пользователя в класс передали nil

- (void) testURLBuilderWithNilFriendID
{
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(testTokenString);
    NSURL *url = [BMVBuilderURLPhotos urlForAllPhotosWithToken:objectMockBMVVkTokenModel forCurrentFriendID:nil];
    expect(url).to.beNil();
}


// Условие - сформируется ли из исходных фрагментов URL'а и токена валидный запрос.

- (void) testURLBuildingWithTokenWithUserAndURLParts
{
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(testTokenString);
    
    NSURL *url = [BMVBuilderURLPhotos urlForAllPhotosWithToken:objectMockBMVVkTokenModel forCurrentFriendID:@"123456"];
    
    NSString *stringForReferenceURL = [NSString stringWithFormat:@"%@%@%@123456%@",BMVFirstPartURL, ([objectMockBMVVkTokenModel tokenString]), BMVSecondPartURL, BMVThirdPartURL];;
    NSURL *urlReference = [NSURL URLWithString:stringForReferenceURL];
    
    expect(url).notTo.beNil();
    expect(url).to.equal(urlReference);
}
@end
