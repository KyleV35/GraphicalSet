//
//  CardCollectionViewCell.h
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/4/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface CardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet CardView *cardView;

@end
