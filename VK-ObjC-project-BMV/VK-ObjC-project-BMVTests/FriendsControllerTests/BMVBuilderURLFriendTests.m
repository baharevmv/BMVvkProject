//
//  BMVBuilderURLFriendTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 12.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVBuilderURLFriend.h"
#import "BMVVkTokenModel.h"

static NSString *const BMVFirstPartURL = @"https://api.vk.com/method/friends.get?access_token=";
static NSString *const BMVSecondPartURL = @"&fields=first_name,last_name,nickname,domain,photo_50,photo_100,"
"photo_max_orig&lang=ru&count=5000&v=5.69";
static NSString *testTokenString = @"123214215215215214124214";

@interface BMVBuilderURLFriendTests : XCTestCase

@end

@implementation BMVBuilderURLFriendTests


// Условие - Вместо Токена в класс передали nil

- (void)testURLBuilderWithNilToken
{
    NSURL *url = [BMVBuilderURLFriend urlForFriendsBuildWithToken:nil];
    expect(url).to.beNil();
}


// Условие - сформируется ли из исходных фрагментов URL'а и токена валидный запрос.

- (void)testURLBuildingWithTokenAndURLParts
{
    id objectMockBMVVkTokenModel = OCMPartialMock([BMVVkTokenModel new]);
    
    OCMStub([objectMockBMVVkTokenModel tokenString]).andReturn(testTokenString);

    NSURL *url = [BMVBuilderURLFriend urlForFriendsBuildWithToken:objectMockBMVVkTokenModel];
    
    NSString *stringForReferenceURL = [NSString stringWithFormat:@"%@%@%@", BMVFirstPartURL, [objectMockBMVVkTokenModel tokenString], BMVSecondPartURL];
    NSURL *urlReference = [NSURL URLWithString:stringForReferenceURL];
    
    expect(url).notTo.beNil();
    expect(url).to.equal(urlReference);
}

@end
