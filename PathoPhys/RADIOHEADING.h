//
//  RADIOHEADING.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 26/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RADIOHEADING : NSObject

@property (nonatomic) NSInteger intRHid;
@property (nonatomic, retain) NSString *strQuestionId;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSString *strHeadingText;
@property (nonatomic, retain) NSArray *arrHeadingText;
@property (nonatomic, retain) NSMutableArray *arrRadioButtons;

@end
