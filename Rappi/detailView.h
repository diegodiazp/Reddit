//
//  detailView.h
//  Rappi
//
//  Created by Diego Diaz Pinilla on 6/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailView : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *displayTxt;
@property (strong, nonatomic) IBOutlet UIWebView *descriptionHTML;
@property NSMutableDictionary *dictReddit;
@property (strong, nonatomic) IBOutlet UIView *viewLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityLoading;
@end
