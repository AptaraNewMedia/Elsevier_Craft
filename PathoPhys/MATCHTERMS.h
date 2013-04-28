//
//  MATCHTERMS.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MATCHTERMS : NSObject

@property (nonatomic) NSInteger intMatchid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions1;
@property (nonatomic, retain) NSArray *arrOptions2;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;
@property (nonatomic, retain) NSString *strCasestudyText;
@end
