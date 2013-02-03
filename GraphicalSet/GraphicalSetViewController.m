//
//  GraphicalSetViewController.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GraphicalSetViewController.h"
#import "GraphicalSetCollectionViewCell.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"

@interface GraphicalSetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame* game;

@end

#define STARTING_CARD_COUNT 20

@implementation GraphicalSetViewController

- (CardMatchingGame*)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:STARTING_CARD_COUNT usingDeck:[[SetCardDeck alloc] init]];
    }
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)asker
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)asker numberOfItemsInSection:(NSInteger)section
{
    return [self.game cardCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"GraphicalSetCard" forIndexPath:indexPath];
    if ([cell isKindOfClass:[GraphicalSetCollectionViewCell class]]) {
        GraphicalSetCollectionViewCell *setCell = (GraphicalSetCollectionViewCell*)cell;
        Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard*)card;
            setCell.setCardView.number = setCard.number;
            setCell.setCardView.color = setCard.color;
            setCell.setCardView.shape = setCard.shape;
            setCell.setCardView.shading = setCard.shading;
            setCell.setCardView.faceUp = setCard.isFaceUp;
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
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    NSLog(@"Hey!");
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    NSIndexPath* path = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    [self.game flipCardAtIndex:path.item];
    GraphicalSetCollectionViewCell* cell = (GraphicalSetCollectionViewCell*) [self.cardCollectionView cellForItemAtIndexPath:path];
    [cell.setCardView setFaceUp:YES];
    [cell.setCardView setNeedsDisplay];
}
@end
