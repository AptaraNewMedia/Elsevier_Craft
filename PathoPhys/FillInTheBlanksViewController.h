//
//  FillInTheBlanksViewController.h
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillInTheBlanksViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *ImgQuestionBg;
    IBOutlet UIImageView *ImgQuestionTextBg;
    IBOutlet UIImageView *ImgQuestionSeperator;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UILabel *lblQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UIScrollView *scrollViewDrag;
    IBOutlet UIImageView *imgViewQue;
    IBOutlet UIScrollView *imgScroller;
    IBOutlet UIView *imgDropView;    
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UILabel *lblQuestionText;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void) fn_LoadDbData:(NSString *)question_id;
-(void) fn_ShowSelected:(NSString *)visitedAnswers;
-(NSString *) fn_CheckAnswersBeforeSubmit;
-(void) fn_OnSubmitTapped;
-(void)Fn_disableAllDraggableSubjects;
-(void) handleShowAnswers;

-(void) rotateScrollViewButtonsForLandscape;
-(void) rotateScrollViewButtonsForPortrait;
@end
