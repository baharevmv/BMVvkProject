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
#import "BMVVkUserModel.h"
#import "BMVDownloadDataService.h"
#import "BMVParsingTokenString.h"

#import "AppDelegate.h"


@interface VKLoginViewController () <UIWebViewDelegate>

//@property (nonatomic, copy) LoginCompletionBlock completionBlock;
@property (nonatomic, weak) UIWebView* webView;

@property (nonatomic, strong) BMVVkTokenModel *theToken;
@property (nonatomic, copy) NSArray <BMVVkUserModel *> *usersArray;

@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;
@property (nonatomic, strong) BMVDownloadDataService *downloadDataService;
@property (nonatomic, strong) BMVParsingTokenString *parsingTokenString;


@end

@implementation VKLoginViewController


- (void) dealloc {
    self.webView.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect typicalRectangle = self.view.bounds;
    typicalRectangle.origin = CGPointZero;
    self.parsingTokenString = [BMVParsingTokenString new];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:typicalRectangle];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    self.navigationItem.title = @"Login";
    NSString* urlString = @"https://oauth.vk.com/authorize?"
                                                        "client_id=6244609&"
                                                        "scope=274438&"
                                                        "redirect_uri=https://oauth.vk.com/blank.html&"
                                                        "display=mobile&"
                                                        "revoke=0&"
                                                        "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
}


#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location == NSNotFound)
    {
        return YES;
    }
    self.theToken = [self.parsingTokenString getTokenFromWebViewHandlerWithRequest:request];
    self.webView.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    VKFriendsViewController *friendsViewController = [VKFriendsViewController new];
    friendsViewController.tokenForFriendsController = self.theToken;
    UINavigationController *friendsNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    friendsNavigationController.tabBarItem.title = @"Friends";
    
    [self presentViewController:friendsNavigationController animated:YES completion:nil];

    return NO;
}

@end
