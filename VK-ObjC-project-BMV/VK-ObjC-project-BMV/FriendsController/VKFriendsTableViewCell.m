//
//  VKFriendsTableViewCellView.m
//  VK-ObjC-project-BMV
//
//  Created by max on 15.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import "VKFriendsTableViewCell.h"
#import "Masonry.h"


static CGFloat const lineSizeImageView = 44.f;
static CGFloat const BMVOffset = 10.0;


@implementation VKFriendsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _userPhotoImageView = [UIImageView new];
        [self.contentView addSubview:_userPhotoImageView];
        
        _userNameLabel = [UILabel new];
        [self.contentView addSubview:_userNameLabel];
        
        
        
//        [self setConstraints];
        [self setMasonryConstraints];
        
    }
    return self;
}

- (void)setMasonryConstraints
{
    [_userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(BMVOffset / 2);
        make.left.equalTo(self.contentView.mas_left).with.offset(BMVOffset);
        make.right.equalTo(self.contentView.mas_left).with.offset(2 * BMVOffset + lineSizeImageView);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-BMVOffset);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(lineSizeImageView / 2);
        make.left.equalTo(_userPhotoImageView.mas_right).with.offset(2 * BMVOffset);
        make.right.equalTo(self.contentView.mas_right).with.offset( - BMVOffset);
    }];
//    [super updateConstraints];
}


- (void)setConstraints
{
    [_userPhotoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_userNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *dictionary =@{
                                @"_userPhotoImageView":_userPhotoImageView,
                                @"_userNameLabel":_userNameLabel,
                                };
    
    NSArray *horizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_userPhotoImageView]-20-[_userNameLabel]-20-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:dictionary];
    
    NSLayoutConstraint * widthConstraints2 = [NSLayoutConstraint constraintWithItem:_userPhotoImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:lineSizeImageView];
    
    NSLayoutConstraint * heightConstraints2 = [NSLayoutConstraint constraintWithItem:_userPhotoImageView
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:lineSizeImageView];
    
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_userPhotoImageView]-20-[_userNameLabel]-30-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:dictionary];
    
    NSArray *verticalConstraints1 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_userNameLabel]-40-|"
                                                                          options:0
                                                                          metrics:nil
                                                                             views:dictionary];
    
    
    [self.contentView addConstraints:horizontalConstraints];
    [self.contentView addConstraint:heightConstraints2];
    [self.contentView addConstraint:widthConstraints2];
    [self.contentView addConstraints:verticalConstraints];
    [self.contentView addConstraints:verticalConstraints1];
}

@end
