//
//  BMVvkPhotosCollectionViewCell.m
//  VK-ObjC-project-BMV
//
//  Created by max on 28.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVvkPhotosCollectionViewCell.h"

@interface BMVvkPhotosCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageToShow;


@end


@implementation BMVvkPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self)
{
    self.backgroundColor = [UIColor whiteColor];
    self.imageToShow = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.imageToShow];
}
return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.image = nil;
    
}

- (void)setImage:(UIImage *)image
{
    self.imageToShow.image = image;
    _image = image;
}


@end
