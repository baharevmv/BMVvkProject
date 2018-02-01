//
//  BMVLoginViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "VKLoginViewController.h"
#import "VKFriendsViewController.h"
#import "BMVgetFriendsJSONData.h"
#import "BMVgetPhotosJSONData.h"
#import "LocalVKToken.h"
#import "BMVvkUserModel.h"
#import "VKAccessToken+CoreDataClass.h"

#import "AppDelegate.h"


@interface VKLoginViewController () <UIWebViewDelegate>

@property (nonatomic, copy) LoginCompletionBlock completionBlock;
@property (nonatomic, weak) UIWebView* webView;

@property (nonatomic, strong) LocalVKToken *theToken;
@property (nonatomic, copy) NSArray <BMVvkUserModel *> *usersArray;

@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@implementation VKLoginViewController


- (void) dealloc {
    self.webView.delegate = nil;
}


- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    self.navigationItem.title = @"Login";
    NSString* urlString = @"https://oauth.vk.com/authorize?"
                                                        "client_id=6244609&"
                                                        "scope=274438&"
                                                        "redirect_uri=https://oauth.vk.com/blank.html&"
                                                        "display=mobile&"
                                                        "v=5.68&"
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

        LocalVKToken* token = [LocalVKToken new];
        NSString* query = [[request URL] description];
        NSArray* array = [query componentsSeparatedByString:@"#"];
        if ([array count] > 1)
        {
            query = [array lastObject];
        }
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        for (NSString* pair in pairs)
        {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            if ([values count] != 2) {
                continue;
            }
                
                NSString* key = [values firstObject];
                if ([key isEqualToString:@"access_token"]) {
                    token.tokenString = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userIDString = [values lastObject];
                    NSLog(@"!!!HERE IS TOKEN %@", token.tokenString);
                    self.theToken = token;
                    NSLog(@"!!!HERE IS SELFTOKEN1 %@", self.theToken.tokenString);
                }
                NSLog(@"!!!HERE IS SELFTOKEN2 %@", self.theToken.tokenString);
            }
        self.webView.delegate = nil; // так не надо -  лучше показать что произошла ошибка.
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIViewController *groupWallVC = [[UIViewController alloc] init];
        UINavigationController *groupNavCon = [[UINavigationController alloc] initWithRootViewController:groupWallVC];
        groupNavCon.tabBarItem.title = @"Groups";
//        groupNavCon.tabBarItem.image = [UIImage imageNamed:@"Wall.png"];
        
        VKFriendsViewController *friendsViewController = [VKFriendsViewController new];
//        NSLog(@"%@",self.theToken.tokenString);
        friendsViewController.tokenForFriendsController = self.theToken;
//        NSLog(@"%@",friendsViewController.tokenForFriendsController.tokenString);
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
        navCon.tabBarItem.title = @"Friends";
//        navCon.tabBarItem.image = [UIImage imageNamed:@"Friends.png"];

        UITabBarController *tabBarContr = [[UITabBarController alloc] init];
        tabBarContr.viewControllers = @[navCon, groupNavCon];

        [self presentViewController:tabBarContr animated:YES completion:nil];
        NSLog(@"!!!HERE IS TOKEN %@", self.theToken.tokenString);
        
        return NO;
}

- (NSManagedObjectContext *) coreDataContext
{
    if (_coreDataContext)
    {
        return _coreDataContext;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSPersistentContainer *container = ((AppDelegate *) (application.delegate)).persistentContainer;
    NSManagedObjectContext *context = container.viewContext;
    return context;
}


- (void) savingTokenToCoreData: (LocalVKToken *)superToken
{
    VKAccessToken *tokenToCoreData = [NSEntityDescription insertNewObjectForEntityForName:@"VKAccessToken" inManagedObjectContext:self.coreDataContext];

    tokenToCoreData.tokenString = superToken.tokenString;
    tokenToCoreData.expirationDate = superToken.expirationDate;
    tokenToCoreData.userIDString = superToken.userIDString;

    NSError *error = nil;
    if (![tokenToCoreData.managedObjectContext save:&error])
    {
        NSLog(@"не удалось сохранить объект");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    error = nil;
    NSArray *result = [self.coreDataContext executeFetchRequest:[VKAccessToken fetchRequest] error:&error]; // error:nil
    for (VKAccessToken *thisToken in result)
    {
        NSLog(@"HEHEHE token - %@ user - %@, and expiration date is %@", thisToken.tokenString, thisToken.userIDString, tokenToCoreData.expirationDate);
    }
    NSLog(@"Results - %@", result);
    //Data To COREDATA SAVED
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
