//
//  PlayingCard.h
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong,nonatomic) NSString* suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray*)validSuits;
+ (NSUInteger)maxRank;

@end
