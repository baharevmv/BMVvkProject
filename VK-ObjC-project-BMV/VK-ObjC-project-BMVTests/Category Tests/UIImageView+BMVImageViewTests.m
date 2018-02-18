//
//  UIImageView+BMVImageViewTests.m
//  VK-ObjC-project-BMVTests
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta.h>
#import <OCMock.h>
#import "UIImageView+BMVImageView.h"


static CGFloat const BMVLineSizeControlView = 10.0;


@interface UIImageView_BMVImageViewTests : XCTestCase

@end

@implementation UIImageView_BMVImageViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBmv_animationOnViewNilSuperview
{
    UIImageView *viewWithAnimation = [UIImageView bmv_animationOnView:nil];
    expect(viewWithAnimation).to.beNil();
}

- (void)testBmv_animationOnViewNotSuperview
{
    UIImageView *viewWithAnimation = [UIImageView bmv_animationOnView:[UITableView new]];
    expect(viewWithAnimation).to.beNil();
}

- (void)testSbt_animationOnView
{
    CGRect frame = CGRectMake(0, 0, BMVLineSizeControlView, BMVLineSizeControlView);
    UIView *controlView = [[UIView alloc] initWithFrame:frame];
    
    id classMockImageView = OCMClassMock([UIImageView class]);

    UIImageView *viewWithAnimation = [UIImageView bmv_animationOnView:controlView];
    
    expect(viewWithAnimation).notTo.beNil();
    expect(viewWithAnimation.center).to.equal(controlView.center);
    expect(viewWithAnimation.image).to.equal([UIImage imageNamed:@"iphone"]);
    
    [classMockImageView stopMocking];
}

@end
