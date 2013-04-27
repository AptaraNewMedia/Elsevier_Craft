//
//  RADIOBUTTONS.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RADIOBUTTONS : NSObject

@property (nonatomic) NSInteger intRBid;
@property (nonatomic) NSInteger intSequence;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSString *strAnswer;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;
@property (nonatomic, retain) NSString *strImagename;

@end
