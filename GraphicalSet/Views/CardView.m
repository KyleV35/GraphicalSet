//
//  CardView.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/4/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setUnplayable:(BOOL)unplayable
{
    _unplayable = unplayable;
    [self setNeedsDisplay];
}

@end
