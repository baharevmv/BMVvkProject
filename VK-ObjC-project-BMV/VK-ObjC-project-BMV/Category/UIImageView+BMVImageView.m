//
//  UIImageView+BMVImageView.m
//  VK-ObjC-project-BMV
//
//  Created by max on 09.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "UIImageView+BMVImageView.h"


static CGFloat const BMVOffset = 40.0;
static CGFloat const BMVWidthsRatio = 2.3;
static CGFloat const BMVPhotosWidthsRatio = 5;
static CGFloat const BMVHeightToWidthRatio = 1.12;
const NSInteger imageCount = 5;

@implementation UIImageView (BMVImageView)


+ (UIImageView *)bmv_animationOnView:(UIView *)superview
{
    
    CGRect bounds = superview.bounds;
    CGFloat sideSquare = CGRectGetWidth(bounds) - BMVOffset;
    CGRect frame = CGRectMake(0, 0, sideSquare, sideSquare);
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:frame];
    phoneView.center = superview.center;
    phoneView.image = [UIImage imageNamed:@"iphone"];
    
    CGRect theBounds = phoneView.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(theBounds), CGRectGetMidY(theBounds));
    CGFloat width = CGRectGetWidth(theBounds) / BMVWidthsRatio;
    CGFloat height = width * BMVHeightToWidthRatio;
    CGRect vkFrame = CGRectMake(0, 0, width, height);
    UIImageView *vkImageView = [[UIImageView alloc] initWithFrame:vkFrame];
    vkImageView.image = [UIImage imageNamed:@"vk1"];
    vkImageView.center = center;
    [phoneView addSubview:vkImageView];
    
    CGRect thePhotosBounds = phoneView.bounds;
    CGPoint thePhotosCenter = CGPointMake(CGRectGetMidX(thePhotosBounds), CGRectGetMidY(thePhotosBounds) + BMVOffset*5);
    CGFloat thePhotosWidth = CGRectGetWidth(thePhotosBounds) / BMVPhotosWidthsRatio;
    CGFloat thePhotosHeight = thePhotosWidth * BMVHeightToWidthRatio;
    CGRect thePhotos = CGRectMake(0, 0, thePhotosWidth, thePhotosHeight);
    UIImageView *photos = [[UIImageView alloc] initWithFrame:thePhotos];
    photos.image = [UIImage imageNamed:@"photos1"];
    photos.center = thePhotosCenter;
    [phoneView addSubview:photos];
    
    NSMutableArray *mutableArrayForImages = [NSMutableArray new];
    for (int i = 1; i < imageCount; i++)
    {
        NSString *imageName = [NSString stringWithFormat: @"photos%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [mutableArrayForImages addObject:image];
    }
    
    photos.animationImages = mutableArrayForImages;
    photos.animationDuration = 1;
    photos.animationRepeatCount = 3;
    [photos startAnimating];
    
    return phoneView;
}

@end
