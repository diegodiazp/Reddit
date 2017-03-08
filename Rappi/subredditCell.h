//
//  subredditCell.h
//  Rappi
//
//  Created by Diego Diaz Pinilla on 6/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subredditCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLbl;
@property (nonatomic, weak) IBOutlet UILabel *suscriptors;
@property (nonatomic, weak) IBOutlet UIImageView *iconImg;

@end
