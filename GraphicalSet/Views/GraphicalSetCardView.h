//
//  GraphicalSetCardView.h
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"
#import "CardView.h"

@interface GraphicalSetCardView : CardView

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shading;

@property (nonatomic) BOOL faceUp;

- (void) populateWithSetCard:(SetCard*)card;

@end
