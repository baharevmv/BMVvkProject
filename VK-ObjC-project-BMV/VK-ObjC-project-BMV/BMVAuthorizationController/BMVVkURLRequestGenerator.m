//
//  BMVVkURLRequestGenerator.m   6244609
//  VK-ObjC-project-BMV
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVVkURLRequestGenerator.h"

static NSString *const BMVFirstPartURL = @"https://oauth.vk.com/authorize?client_id=6355197";
static NSString *const BMVSecondPartURL = @"&scope=274438&redirect_uri=https://oauth.vk.com/blank.html&"
                                        "display=mobile&revoke=0&response_type=token";


@interface BMVVkURLRequestGenerator ()

@property (nonatomic, assign) NSString *appClientId;

@end

@implementation BMVVkURLRequestGenerator

- (NSURLRequest *)makingRequest
{
    NSString *BMVurlString = [NSString stringWithFormat:@"%@%@",BMVFirstPartURL, BMVSecondPartURL];
    NSURL *url = [NSURL URLWithString:BMVurlString];
    NSURLRequest *request = [NSURLRequest new];
    request = [NSURLRequest requestWithURL:url];
    return request;
}

@end
