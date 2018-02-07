////
////  BMVProgressView.m
////  VK-ObjC-project-BMV
////
////  Created by max on 19.01.18.
////  Copyright © 2018 Maksim Bakharev. All rights reserved.
////
//
//#import "BMVProgressView.h"
//
//static const CGFloat progressHeight = 50;
//
//@interface BMVProgressView()
//
//@property (nonatomic, strong) UILabel *progressLabel;
//@property (nonatomic, strong) UIView *progressView;
////@property (
//
//@end
//
//@implementation BMVProgressView
//
//- (instancetype) initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(self)
//    {
//        _progressLabel = [UILabel new];
//        _progressLabel.frame = CGRectMake (0, 0, CGRectGetWidth(frame), 40);
//        [self addSubview:_progressLabel];
//
//        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressLabel.frame), CGRectGetWidth(frame) , progressHeight)];
//        _progressView.backgroundColor = [UIColor blueColor];
//        [self addSubview:_progressView];
//
//    }
//    return self;
//}
//
//- (void)startProgressAnimation
//{
//
//}
//
//- (void)stopProgressAnimation
//{
//
//}
//
//
//- (void) setIsAnimationRunning: (BOOL) isAnimationRunning
//{
//
//    [UIView animateWithDuration: 0.3 animations:^ {
//        self.progressHeight.center = CGPointMake(self.ballView.center.x, self.ballView.center.y - progressHeight * 3);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:<#(NSTimeInterval)#> animations:<#^(void)animations#>]
//    }];
//
//}
//
////- (void)didMoveToSuperview
////{
////    [super didMoveToSuperview];
////    [self startAnimation]
////}
//
//- (CGFloat)getWidthDependOnProgress
//{
//    return CGRectGetWidth(self.frame) * _progress;
//}
//# pragma mark - Setters
//
//- (void) setProgress: (CGFloat)progress
//{
//    _progress = progress;
//    self.progressLabel.text = [NSString stringWithFormat:@"%f%%", progress];
//    self.progressView.frame = CGRectMake(CGRectGetMinX(self.progressView.frame), CGRectGetMinY(self.progressView.frame), [self getWidthDependOnProgress], <#CGFloat height#>)
//    if (progress >= 100)
//    {
//        [self.progressView removeFromSuperview];
//        [self.progressLabel removeFromSuperview];
//    }
//}
//
//
//@end

