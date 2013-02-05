//
//  CardMatchingGameViewController.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/4/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardMatchingGameViewController.h"

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

#import "CardCollectionViewCell.h"
#import "PlayingCardView.h"

@interface CardMatchingGameViewController ()

@end

#define STARTING_NUMBER_OF_CARDS 22;
#define CARDS_TO_MATCH 2

@implementation CardMatchingGameViewController

- (NSUInteger)startingCardCount
{
    return STARTING_NUMBER_OF_CARDS;
}

- (Deck*)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    return CARDS_TO_MATCH;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    if ([cell isKindOfClass:[CardCollectionViewCell class]]) {
        CardCollectionViewCell *playingCardCell = (CardCollectionViewCell*)cell;
        Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard*)card;
            if ([playingCardCell.cardView isKindOfClass:[PlayingCardView class]]) {
                PlayingCardView* playingCardView = (PlayingCardView*)playingCardCell.cardView;
                [self populateView:playingCardView withCard:playingCard];
            }
            
        } else {
            NSLog(@"Card from cardAtIndex at index:%u was not a SetCard.",(NSUInteger)indexPath.item);
            exit(1);
        }
    } else {
        NSLog(@"Cell from cardCollectionView was not a GraphicalSetCollectionViewCell.");
        exit(1);
    }
    return cell;
}

- (void)populateView:(CardView*)cardView withCard:(Card*)card
{
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard* playingCard = (PlayingCard*)card;
        if ([cardView isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView* playingCardView = (PlayingCardView*)cardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.unplayable = playingCard.isUnplayable;
        } else {
            NSLog(@"Not a PlayingCardView!");
            exit(1);
        }
    } else {
        NSLog(@"Not a PlayingCard!");
        exit(1);
    }
}

- (CardView*)createCardView
{
    return [[PlayingCardView alloc] init];
}

@end
