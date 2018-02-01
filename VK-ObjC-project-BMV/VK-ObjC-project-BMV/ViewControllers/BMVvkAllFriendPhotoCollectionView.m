//
//  BMVvkAllFriendPhotoCollectionViewController.m
//  VK-ObjC-project-BMV
//
//  Created by max on 27.01.18.
//  Copyright © 2018 Maksim Bakharev. All rights reserved.
//


#import "BMVvkAllFriendPhotoCollectionView.h"
#import "BMVvkPhotosCollectionViewCell.h"
#import "BMVvkPhotoModel.h"
#import "BMVvkUserModel.h"
#import "LocalVKToken.h"
#import "BMVgetPhotosJSONData.h"

static NSString *cellIdentifier = @"CellIdentifier";
NSInteger const offsetLeft = 20;
NSInteger const offsetTop = 5;

@interface BMVvkAllFriendPhotoCollectionView ()

//@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) NSUInteger numberPage;
@property (nonatomic, copy) BMVvkUserModel *viewedUser;
@property (nonatomic, copy) NSMutableArray <BMVvkPhotoModel *> *modelArray;  // strong - NSArray
@property (nonatomic, retain) NSMutableArray <BMVvkPhotoModel *> *selectedModelArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic) NSMutableArray  *arrayWithSelectedIndexPath;


@end

@implementation BMVvkAllFriendPhotoCollectionView


- (void) viewDidLoad
{
    self.arrayWithSelectedIndexPath = [NSMutableArray new];
    self.selectedModelArray = [NSMutableArray <BMVvkPhotoModel *> new];
    [super viewDidLoad];
    // Собираем модель
    [self gettingAllUsersPhoto:self.interestingUser token:self.tokenForFriendsController];
    // Настраиваем flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 2.0f;
    flowLayout.minimumLineSpacing = 2.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    flowLayout.itemSize = CGSizeMake(100, 100);
    self.collectionView.collectionViewLayout = flowLayout;
    
    // Настраиваем collectionView
    [self.collectionView registerClass:[BMVvkPhotosCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save All" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAllPhotos)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//-(instancetype)init
//{
//    self = [super init];
//    if (self)
//    {
//        _selectedModelArray = [NSMutableArray new];
//    }
//    return self;
//}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"DOWNLOADED");
        return;
    }
    
    NSLog(@"We got an Error here - %@", error);
}
- (void) downloadAllPhotos
{
    //    if(self.arrayIndexPath.count > 0)
    //    {
    //        [self.collectionView performBatchUpdates:^{
    //            [self.collectionView deleteItemsAtIndexPaths:self.arrayIndexPath];
    //            [self.arrayIndexPath removeAllObjects];
    //        } completion:nil];
    //    }
    
    // network animation on
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // save image from the web
    NSLog(@"КОЛИЧЕСТВО %lu",(unsigned long)self.selectedModelArray.count);
    if (self.selectedModelArray.count != 0 )
    {
        NSLog(@"%@", self.selectedModelArray);
        for (BMVvkPhotoModel *photo in self.selectedModelArray)
        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)), ^{
            
//            UIImage *щкшпштфдЗрщещЗфер = [[NSString alloc] initWithFormat:@"%@",photo.orinalImageURL];
//            SEL __imageDownloaded = @selector(image:didFinishSavingWithError:contextInfo:
            // и заменить их
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
            NSLog(@"%@", originalPhotoPath);
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:originalPhotoPath]]], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                
//            [self performSelectorOnMainThread:@selector(imageDownloaded) withObject:nil waitUntilDone:YES ];  // это делать нельзя!!! - удаляем.
            // делвемм вот так
            //            dispatch_async(dispatch_getmain_queue(), ^{
            //            [self imageDownloaded];
//
            //
            });
            }
//        }
//                           }
    
        
    } else {
        NSLog(@"%@", self.modelArray);
        for (BMVvkPhotoModel *photo in self.modelArray)
        {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *originalPhotoPath = [[NSString alloc] initWithFormat:@"%@",photo.mediumImageURL];
                NSLog(@"%@", originalPhotoPath);
                UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:originalPhotoPath]]], self, /*@selector(image:didFinishSavingWithError:contextInfo:)*/nil, nil);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                    [self performSelectorOnMainThread:@selector(imageDownloaded) withObject:nil waitUntilDone:YES ];
//                });
            });
        }
    }
}

    
- (void)imageDownloaded
{
    
    // network animation on
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)gettingAllUsersPhoto:(BMVvkUserModel *)currentUser token:(LocalVKToken *)token
{
    [self.modelArray removeAllObjects];
    self.numberPage = 1;
    
    [BMVgetPhotosJSONData NetworkWorkingWithPhotosJSON:token currentFriend:currentUser completeBlock:^(NSMutableArray <BMVvkPhotoModel *> *photos)
     {
         self.modelArray = photos;
        [self.collectionView reloadData];
     }];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BMVvkPhotosCollectionViewCell *collectionViewCell = (BMVvkPhotosCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    [collectionViewCell prepareForReuse];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *previewPhotoPath = [[NSString alloc] initWithFormat:@"%@",self.modelArray[indexPath.row].previewImageURL];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: previewPhotoPath]];
            dispatch_async(dispatch_get_main_queue(), ^{
                collectionViewCell.image = [UIImage imageWithData: imageData];
            });
    });
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.arrayWithSelectedIndexPath addObject:indexPath];
    [self.selectedModelArray addObject:self.modelArray[indexPath.item]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAllPhotos)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


@end

