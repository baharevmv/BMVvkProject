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
//    self.imageToShow = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageToShow = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 1, 1)];
    [self.contentView addSubview:self.imageToShow];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor redColor];
    self.selectedBackgroundView = selectedBackgroundView;
}
return self;
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    // сбрасываем цвета и image
//    self.backgroundColor = [UIColor whiteColor];
//    self.imageToShow = nil;
//}



-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (self.highlighted)
    {
        self.imageToShow.alpha = 0.8f;
    }
    else
    {
        self.imageToShow.alpha = 1.0f;
    }
}

#pragma mark - Overridden Properties

- (void)setImage:(UIImage *)image
{
    self.imageToShow.image = image;
    _image = image;
}

@end
