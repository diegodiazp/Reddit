//
//  sudRedditiPadCell.h
//  Rappi
//
//  Created by Diego Diaz Pinilla on 7/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sudRedditiPadCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblSuscriptors;
@end
