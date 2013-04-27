//
//  MultipleSelectionViewController.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 29/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleSelectionViewController : UIViewController
{
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UILabel *lblQuestionText;
    IBOutlet UILabel *lblInstructions;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UILabel *lblQuestionText;
@property (nonatomic, retain) IBOutlet UILabel *lblInstructions;

-(void) fn_LoadDbData:(NSString *)question_id;

@end
