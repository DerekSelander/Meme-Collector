//
//  Meme.h
//  Meme Collector
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Selander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchasableItemProtocol.h"
@interface Meme : NSObject <PurchasableItemProtocol>
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)memePurchased;
@end
