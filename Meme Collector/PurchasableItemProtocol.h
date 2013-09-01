//
//  MoneyProtocol.h
//  Reverse Me
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PurchasableItemProtocol <NSObject>
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSNumber *purchaseCount;

@end
