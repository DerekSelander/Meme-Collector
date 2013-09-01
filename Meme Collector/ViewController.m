
//
//  ViewController.m
//  Reverse Me
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import "ViewController.h"
#import "MoneyManager.h"
#import "PurchasableItemProtocol.h"
#import "PurchaseableItemCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "MemeManager.h"
#import <QuartzCore/QuartzCore.h>

#define kPurchaseItemIndex 1  ///Used for UIAlertView index

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.memeDescriptionTextView.clipsToBounds = YES;
    self.memeDescriptionTextView.layer.cornerRadius = 20.0f;
    [self.moneyLabel sizeToFit];
    self.moneyLabel.text = [[MoneyManager sharedManager] money].stringValue;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTransactionInfo:) name:kCurrencyExchangeOccurredNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMeme:) name:kDownloadJSONCompletedNotification object:nil];
}

- (void)performPurchaseAnimationWithIndexPath:(NSIndexPath *)indexPath
{
    [self.ItemCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}

//*****************************************************************************/
#pragma mark - NSNotifications Methods
//*****************************************************************************/

- (void)addMeme:(NSNotification *)notification
{
    NSNumber *indexNumber = notification.userInfo[@"position"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexNumber.integerValue inSection:0];
    
    [self.ItemCollectionView performBatchUpdates:^{
        [self.ItemCollectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}

- (void)updateTransactionInfo:(NSNotification *)notification
{
    self.moneyLabel.text = [[MoneyManager sharedManager] money].stringValue;
}


//*****************************************************************************/
#pragma mark - UICollectionViewDataSource Methods
//*****************************************************************************/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [MemeManager sharedManager].memes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PurchaseableItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    
    id<PurchasableItemProtocol> item = [MemeManager sharedManager].memes[indexPath.row];
    cell.itemImageView.image = [item image];
    cell.itemTitleLabel.text = [item title];
    cell.itemCostLabel.text = [item cost].stringValue;
    cell.purchaseCountLabel.text = [item purchaseCount].stringValue;
    cell.infoButton.tag = indexPath.row;
    [cell.infoButton addTarget:self action:@selector(cellInfoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


//*****************************************************************************/
#pragma mark - UICollectionViewDelegate Methods
//*****************************************************************************/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    id<PurchasableItemProtocol>item = [MemeManager sharedManager].memes[index];
    if ([[MoneyManager sharedManager] buyObject:item]) {
        [[MemeManager sharedManager] memePurchased:indexPath.row];
        [self performPurchaseAnimationWithIndexPath:indexPath];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Enough Money"
                                                        message:@"Please purchase more money to complete this transaction"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//*****************************************************************************/
#pragma mark - IBAction Methods
//*****************************************************************************/
- (IBAction)purchaseCurrency:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase App Currency"
                                                    message:@"Would you like to purchase more app currency for $0.99 ?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)cellInfoButtonPushed:(id)sender
{
    if (self.memeDescriptionTextView.hidden) {
        self.memeDescriptionTextView.hidden = NO;
        self.memeDescriptionTextView.alpha = 0.0f;
        [UIView animateWithDuration:0.4f animations:^{
            self.memeDescriptionTextView.alpha = 1.0f;
        }];
    }
    UIButton *button = (UIButton *)sender;
    id<PurchasableItemProtocol>item = [MemeManager sharedManager].memes[button.tag];
    NSString *memeDescriptionText = [NSString stringWithFormat:@"Description: %@", [item itemDescription]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:memeDescriptionText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, 12)];
    
    self.memeDescriptionTextView.attributedText = attributedString;
    
}

//*****************************************************************************/
#pragma mark - UIAlertViewDelegate Methods
//*****************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kPurchaseItemIndex) {
        [SVProgressHUD showWithStatus:@"Purchasing Goods"];
        
        //Simulate network interaction by applying a delay and showing a progress hud
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressHUD dismiss];
            
            //In a real app, this logic will likely be found somewhere in the StoreKit success delegate/callbacks
            if ([[MoneyManager sharedManager] purchaseCurrency]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"You have purchased more currency"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"There was an error purchasing app currency"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    }
}

@end
