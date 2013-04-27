//
//  SingleSelectionImageViewController.h
//  PathoPhys
//
//  Created by Rohit Yermalkar on 26/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectionImageViewController : UIViewController
{
    IBOutlet UIImageView *ImgQuestionBg;
    IBOutlet UIImageView *ImgQuestionTextBg;
    IBOutlet UIImageView *ImgQuestionSeperator;

    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UITextView *lblQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UITableView *tblOptions;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UITextView *lblQuestionText;
@property (nonatomic, retain) IBOutlet UILabel *lblInstructions;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void) fn_LoadDbData:(NSString *)question_id;

-(void) fn_CheckAnswersBeforeSubmit;
-(void) fn_OnSubmitTapped;

@end
