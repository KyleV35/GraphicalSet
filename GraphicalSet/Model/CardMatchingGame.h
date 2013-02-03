//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kyle Vermeer on 1/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card*)cardAtIndex:(NSUInteger)index;
- (void)setNumberOfCardsToMatch:(NSUInteger)numberToMatch;

@property (nonatomic, readonly, getter=resultsOfLastFlip) NSArray* resultsOfLastFlip;
@property (nonatomic,readonly) int score;
@property (nonatomic,readonly) NSUInteger cardCount;

@end
