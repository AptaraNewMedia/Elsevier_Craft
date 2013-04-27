//
//  TRUEFLASE.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUEFLASE : NSObject

@property (nonatomic) NSInteger intTrueid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSString *strOptions1;
@property (nonatomic, retain) NSString *strOptions2;
@property (nonatomic, retain) NSString *strAnswer;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;

@end
