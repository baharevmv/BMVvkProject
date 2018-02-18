//
//  BMVLoginViewController.m 
//  VK-ObjC-project-BMV 6355197
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVVkLoginViewController.h"
#import "BMVVkFriendsViewController.h"
#import "BMVVkTokenModel.h"
#import "BMVParsingTokenString.h"
#import "UIImageView+BMVImageView.h"
#import "BMVVkURLRequestGenerator.h"


@interface BMVVkLoginViewController () <UIWebViewDelegate>


@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BMVVkTokenModel *theToken;
@property (nonatomic, strong) BMVParsingTokenString *parsingTokenString;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) BMVVkURLRequestGenerator *requestGenerator;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) NSTimer *timer;


@end


@implementation BMVVkLoginViewController


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _parsingTokenString = [BMVParsingTokenString new];
        _requestGenerator = [BMVVkURLRequestGenerator new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect typicalRectangle = self.view.bounds;
    typicalRectangle.origin = CGPointZero;
    
    self.webView = [[UIWebView alloc] initWithFrame:typicalRectangle];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];
    
    self.navigationItem.title = @"Login";
    self.request = [self.requestGenerator makingRequest];

    self.animationView = [UIView new];
    self.animationView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.animationView];
    
    [self.animationView addSubview:[UIImageView bmv_animationOnView:self.view]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(actionTimerRemoveAnimationViewAuthorizarion)
                                                userInfo:nil
                                                 repeats:NO];
}


#pragma mark - Animations

- (void)actionTimerRemoveAnimationViewAuthorizarion
{
    [self.animationView removeFromSuperview];
    [self.timer invalidate];
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];

}


#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] description] rangeOfString:@"#access_token="].location == NSNotFound)
    {
        return YES;
    }
    self.theToken = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:request];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    BMVVkFriendsViewController *friendsViewController = [BMVVkFriendsViewController new];
    friendsViewController.tokenForFriendsController = self.theToken;
    UINavigationController *friendsNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    friendsNavigationController.tabBarItem.title = @"Friends";
    [self presentViewController:friendsNavigationController animated:YES completion:nil];
    return NO;
}

@end
