//
//  BMVLoginViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "VKLoginViewController.h"
#import "VKFriendsViewController.h"
#import "BMVVkTokenModel.h"
#import "BMVParsingTokenString.h"
#import "AppDelegate.h"


static NSString *const BMVurlString = @"https://oauth.vk.com/authorize?"
                                                    "client_id=6244609&"
                                                    "scope=274438&"
                                                    "redirect_uri=https://oauth.vk.com/blank.html&"
                                                    "display=mobile&"
                                                    "revoke=0&"
                                                    "response_type=token";


@interface VKLoginViewController () <UIWebViewDelegate>


@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) BMVVkTokenModel *theToken;
@property (nonatomic, strong) BMVParsingTokenString *parsingTokenString;


@end


@implementation VKLoginViewController


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _parsingTokenString = [BMVParsingTokenString new];
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
    NSURL* url = [NSURL URLWithString:BMVurlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}


#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location == NSNotFound)
    {
        return YES;
    }
    self.theToken = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:request];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    VKFriendsViewController *friendsViewController = [VKFriendsViewController new];
    friendsViewController.tokenForFriendsController = self.theToken;
    UINavigationController *friendsNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    friendsNavigationController.tabBarItem.title = @"Friends";
    [self presentViewController:friendsNavigationController animated:YES completion:nil];
    return NO;
}

@end
