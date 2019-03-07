//
//  BMVURLRequestGenerator.m   6244609
//  VK-ObjC-project-BMV
//
//  Created by max on 16.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVURLRequestGenerator.h"

static NSString *const BMVSinglePartURL = @"https://oauth.vk.com/authorize?client_id=6355197"
											"&scope=270342&redirect_uri=https://oauth.vk.com/blank.html&"
											"display=mobile&revoke=0&response_type=token";

@implementation BMVURLRequestGenerator

- (NSURLRequest *)makingRequest
{
	NSString *BMVUrlString = [NSString stringWithFormat:@"%@",BMVSinglePartURL];
	NSURL *url = [NSURL URLWithString:BMVUrlString];
	NSURLRequest *request = [NSURLRequest new];
	request = [NSURLRequest requestWithURL:url];
	return request;
}

@end
