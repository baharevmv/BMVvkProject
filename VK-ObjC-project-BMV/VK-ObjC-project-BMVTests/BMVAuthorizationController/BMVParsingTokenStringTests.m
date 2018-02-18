//
//  BMVParsingTokenStringTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <Expecta.h>
#import "BMVParsingTokenString.h"
#import "BMVVkTokenModel.h"

@interface BMVParsingTokenStringTests : XCTestCase

@property (nonatomic, strong) BMVParsingTokenString *parsingTokenString;

@end

@implementation BMVParsingTokenStringTests

- (void)setUp {
    [super setUp];
    self.parsingTokenString = ([BMVParsingTokenString new]);
}

- (void)tearDown {
    self.parsingTokenString = nil;
    [super tearDown];
}


// Условие - В качестве аргумента нет никаких входных данных - nil. BMVVkTokenModel - nil

- (void)testRequestToModelNilRequest
{
    BMVVkTokenModel *token = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:nil];
    expect(token).to.beNil();
}


// Условие - Если запрос не nil, но пустая строка, то BMVVkTokenModel - nil

- (void)testRequestToModelEmptyRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@""]];
    NSURLRequest *request = [NSURLRequest new];
    request = [NSURLRequest requestWithURL:url];
    BMVVkTokenModel *token = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:request];
    expect(request).notTo.beNil();
    expect(token).to.beNil();
}


// Условие - насколько корректно заполняются поля у модели

- (void)testRequestToModelParsing
{
    NSURL *url = [NSURL URLWithString:@"https://oauth.vk.com/blank.html#access_token=dc6490505c102d37f61c&expires_in=86400&user_id=57630"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    BMVVkTokenModel *token = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:request];
    expect(token).notTo.beNil();
    expect(token.tokenString).to.equal(@"dc6490505c102d37f61c");
    expect(token.expirationDate).notTo.beNil();
    expect(token.userIDString).to.equal(@"57630");
}

@end
