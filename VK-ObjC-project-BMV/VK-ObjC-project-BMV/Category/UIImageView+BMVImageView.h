//
//  UIImageView+BMVImageView.h
//  VK-ObjC-project-BMV
//
//  Created by max on 09.02.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Категория класса UIImageView
 */
@interface UIImageView (BMVImageView)


/**
 Создает анимацию при загрузке приложения
 @param superview - вью, на которой будет располагаться image view с анимацией.
 @return imageView с анимацией
 */
+ (UIImageView *)bmv_animationOnView:(UIView *)superview;


@end
