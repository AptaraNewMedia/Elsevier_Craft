//
//  NSObject+DragDropRadio.h
//  PathoPhys
//
//  Created by Rohit Yermalkar on 17/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DragDropRadio: NSObject

@property (nonatomic) NSInteger intDRAGDROPRADIOid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSArray *arrOptionsText;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSArray *arrXYpoints;
@property (nonatomic, retain) NSArray *arrXYpointsRadioButton;
@property (nonatomic, retain) NSArray *arrRadioOptions;
@property (nonatomic, retain) NSArray *arrRadioAnswers;
@property (nonatomic) float fWidth;
@property (nonatomic) float fHeight;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSString *strFeedback;
@property (nonatomic, retain) NSString *strInstruction;
@property (nonatomic, retain) NSMutableArray *arrFeedback;

@end
