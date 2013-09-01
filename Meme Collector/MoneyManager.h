//
//  MoneyManager.h
//  Reverse Me
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchasableItemProtocol.h"
#import <StoreKit/StoreKit.h>


@interface MoneyManager : NSObject

/*!
 The amount of money the user currently has
 @return an NSNumber containing an NSInteger of the user currency
 */
@property (nonatomic, strong, readonly) NSNumber *money;

/*!
 Singleton app currency manager
 */
+ (MoneyManager *)sharedManager; 

/*!
 Lets the user purchase more app currency. This method will trigger 100 app currency to be given to the user
 @return    Returns YES on success; NO on failure
 */
- (BOOL)purchaseCurrency;

/*!
 Purchases a virtual item using app curency
 @param     object Purchases the object object that forms to \p PurchasableItemProtocol protocol
 @return    Returns YES on success; NO on failure
 */
- (BOOL)buyObject:(id<PurchasableItemProtocol>)object; 

@end
