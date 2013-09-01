//
//  MoneyManager.m
//  Reverse Me
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import "MoneyManager.h"

#define kMoneyKey @"userCurrency"

@implementation MoneyManager 

//*****************************************************************************/
#pragma mark - Public Methods
//*****************************************************************************/

+ (MoneyManager *)sharedManager
{
    static MoneyManager *sharedMoneyManager = nil;
    if (!sharedMoneyManager) {
        sharedMoneyManager = [[MoneyManager alloc] init];
        [sharedMoneyManager loadState];
    }

    return sharedMoneyManager;
}

- (BOOL)buyObject:(id<PurchasableItemProtocol>)object
{
    NSUInteger totalMoney = self.money.unsignedIntegerValue;
    NSUInteger cost = [object cost].unsignedIntegerValue;
    
    if (totalMoney < cost) {
        return NO;
    }
    
    _money = @(totalMoney - cost);
    
    return [self saveState];
}

- (BOOL)purchaseCurrency
{
    NSUInteger totalAmount = self.money.unsignedIntegerValue;
    NSUInteger addedAmount = 100;
    _money = @(totalAmount + addedAmount);
    
    return [self saveState];
}


//*****************************************************************************/
#pragma mark - "Private" Methods
//*****************************************************************************/

- (void)loadState
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [bundlePath stringByAppendingPathComponent:@"MoneyDataStore.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    _money = [plistData objectForKey:kMoneyKey];
}

- (BOOL)saveState
{
    NSDictionary *plistDictionary = @{kMoneyKey: _money};
    NSString *pathToPlist = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"MoneyDataStore.plist"];
    BOOL didSucceed = [plistDictionary writeToFile:pathToPlist atomically:YES];
    if (didSucceed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrencyExchangeOccurredNotification object:nil];
    }
    return didSucceed;
}

@end
