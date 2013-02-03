//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init
{
    self = [super init];
    if (self) {
        // Every combination of card
        for (NSUInteger shape=0; shape <= [SetCard maxShape]; shape++) {
            for (NSUInteger number=0; number <= [SetCard maxNumber]; number++) {
                for (NSUInteger shading=0; shading <= [SetCard maxShading]; shading++) {
                    for (NSUInteger color=0; color <= [SetCard maxColor]; color++) {
                        SetCard* card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.number = number;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
