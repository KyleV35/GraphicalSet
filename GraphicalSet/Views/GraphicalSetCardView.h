//
//  GraphicalSetCardView.h
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

@interface GraphicalSetCardView : UIView

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shading;

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL unplayable;

- (void) populateWithSetCard:(SetCard*)card;

@end
