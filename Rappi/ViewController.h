//
//  ViewController.h
//  Rappi
//
//  Created by Diego Diaz on 4/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability; 

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UITableView *tableCategories;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionSubReddits;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleiPad;
@property (strong, nonatomic) IBOutlet UIView *viewLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityLoading;


@end

