//
//  BMVPhotosCollectionViewCell.m
//  VK-ObjC-project-BMV
//
//  Created by max on 28.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "BMVPhotosCollectionViewCell.h"


static CGFloat const BMVOffset = 2.0;


@interface BMVPhotosCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageToShow;

@end


@implementation BMVPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.imageToShow = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, BMVOffset, BMVOffset)];
		[self.contentView addSubview:self.imageToShow];
		
		UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		selectedBackgroundView.backgroundColor = [UIColor redColor];
		self.selectedBackgroundView = selectedBackgroundView;
	}
	return self;
}


- (void)setImage:(UIImage *)image
{
	self.imageToShow.image = image;
	_image = image;
}

@end
