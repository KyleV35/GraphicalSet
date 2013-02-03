//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;

// Lets the game know how many cards it should be matching
@property (nonatomic) NSUInteger numCardsToMatch;
@property (strong, nonatomic) NSMutableArray *lastFlipArray;

#define DEFAULT_NUM_CARDS_TO_MATCH 2
@end

@implementation CardMatchingGame

/* Lazy instantiation */

-(NSMutableArray*) lastFlipArray
{
    if (!_lastFlipArray) _lastFlipArray = [[NSMutableArray alloc] init];
    return _lastFlipArray;
}

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSUInteger) cardCount
{
    return [self.cards count];
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i=0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    self.numCardsToMatch = DEFAULT_NUM_CARDS_TO_MATCH;
    return self;
}

- (Card*) cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define SET_MATCH_BONUS 6

- (void) flipCardAtIndex:(NSUInteger)index
{
    Card* card = [self cardAtIndex:index];
    bool wasMatchOrMismatch = NO;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            //If this flip will turn some card face up, empty the old flip array
            [self.lastFlipArray removeAllObjects];
            
            if (self.numCardsToMatch == 2) {
                wasMatchOrMismatch = [self handleTwoCardMatch:card];
            } else if (self.numCardsToMatch ==3) {
                wasMatchOrMismatch = [self handleThreeCardMatch:card];
            } else {
                NSLog(@"Unable to match %d cards", self.numCardsToMatch);
            }
            
            // Subtract points for flipping
            self.score -= FLIP_COST;
            
            // If there was no match or mismatch, result of last flip is just one card
            if (!wasMatchOrMismatch) {
                [self.lastFlipArray addObjectsFromArray:@[card,@(-FLIP_COST)]];
            }
        }
        card.faceUp = !card.isFaceUp;
    }
}

/* Checks to see if two cards are turned face up.  If two cards are face up,
 * it checks if they are a match or not and updates the score accordingly.  Return YES
 * if there was a match or a mismatch, returns NO if only one card is faceup.
 */
-(BOOL)handleTwoCardMatch:(Card*)card
{
    for (Card* otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            int matchScore = [card match:@[otherCard]];
            if (matchScore) {
                // Update Score
                int pointsAwarded = matchScore * MATCH_BONUS;
                self.score += pointsAwarded;
                
                // Make cards unplayable
                otherCard.unplayable = YES;
                card.unplayable = YES;
                
                [self.lastFlipArray addObjectsFromArray:@[card,otherCard,@(pointsAwarded)]];
            } else {
                // Update Score
                int pointsSubtracted = MISMATCH_PENALTY;
                self.score -= pointsSubtracted;
                
                // Turn other card over
                otherCard.faceUp = NO;
                [self.lastFlipArray addObjectsFromArray:@[card,otherCard,@(-pointsSubtracted)]];
            }
            return YES;
        }
    }
    // Only one card is faceup
    return NO;
}

/* Checks to see if three cards are turned face up.  If three cards are face up,
 * it checks if they are a match or not and updates the score accordingly.  Return YES
 * if there was a match or a mismatch, returns NO if only one or two cards are faceup.
 */
-(BOOL)handleThreeCardMatch:(Card*)card
{
    Card* firstCard = nil;
    Card* secondCard = nil;
    for (Card* otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            if (!firstCard) {
                firstCard = otherCard;
            } else {
                secondCard = otherCard;
                break;
            }
        }
    }
    // If only two cards are turned up, return NO
    if (!secondCard) {
        return NO;
    } else {
        int matchScore = [card match:@[firstCard,secondCard]];
        if (matchScore) {
            int pointsAwarded = matchScore * SET_MATCH_BONUS;
            self.score += pointsAwarded;
            firstCard.unplayable = YES;
            secondCard.unplayable = YES;
            card.unplayable = YES;
            [self.lastFlipArray addObjectsFromArray:@[card, firstCard, secondCard, @(pointsAwarded)]];
        } else {
            int pointsSubtracted = MISMATCH_PENALTY;
            self.score -= pointsSubtracted;
            firstCard.faceUp = NO;
            secondCard.faceUp = NO;
            [self.lastFlipArray addObjectsFromArray:@[card, firstCard, secondCard, @(-pointsSubtracted)]];
        }
        return YES;
    }
    return NO;
}



- (NSArray*)resultsOfLastFlip
{
    return [NSArray arrayWithArray:self.lastFlipArray];
}

-(void)setNumberOfCardsToMatch:(NSUInteger)numberToMatch
{
    self.numCardsToMatch = numberToMatch;
}

@end
