//
//  BMVLoginViewController.h
//  VK-ObjC-project-BMV
//
//  Created by max on 11.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalVKToken;

typedef void(^LoginCompletionBlock)(LocalVKToken* token);

@interface VKLoginViewController : UIViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
