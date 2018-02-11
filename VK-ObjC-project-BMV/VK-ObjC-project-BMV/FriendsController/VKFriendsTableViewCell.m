//
//  VKFriendsTableViewCellView.m
//  VK-ObjC-project-BMV
//
//  Created by max on 15.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "VKFriendsTableViewCell.h"
#import "Masonry.h"


static CGFloat const lineSizeImageView = 60.0;
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
        
        [self setMasonryConstraints];
    }
    return self;
}


- (void)setMasonryConstraints
{
    [_userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(BMVOffset/5);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(BMVOffset);
        make.size.mas_equalTo(CGSizeMake(lineSizeImageView, lineSizeImageView));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-BMVOffset/5);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(BMVOffset);
        make.left.mas_equalTo(_userPhotoImageView.mas_right).with.offset(BMVOffset * 2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-BMVOffset);
    }];
}

@end
