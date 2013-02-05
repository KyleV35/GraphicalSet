//
//  CardPlayingGameViewController.h
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/4/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardMatchingGame.h"
#import "Deck.h"
#import "CardView.h"

@interface CardPlayingGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

- (IBAction)dealPressed;


/* Virtual Function, should be overwritten by subclass */
@property (nonatomic, readonly) NSUInteger startingCardCount;
@property (nonatomic, readonly) NSUInteger numberOfCardsToMatch;
- (Deck*)createDeck;
- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)populateView:(CardView*)cardView withCard:(Card*)card;
- (CardView*) createCardView;
@end
