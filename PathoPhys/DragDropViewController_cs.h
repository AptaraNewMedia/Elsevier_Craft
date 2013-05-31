//
//  DragDropViewController.h
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragDropViewController_cs : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *ImgQuestionBg;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UIWebView *webQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UIScrollView *scrollViewDrag;
    IBOutlet UIImageView *imgViewQue;
    IBOutlet UIScrollView *imgScroller;
    IBOutlet UIView *imgDropView;
    IBOutlet UIButton *btnCasestudyText;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UIWebView *webQuestionText;
@property (nonatomic, retain) IBOutlet UILabel *lblInstructions;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void)fn_LoadDbData:(NSString *)question_id;
-(void)fn_ShowSelected:(NSString *)visitedAnswers;
-(NSString *)fn_CheckAnswersBeforeSubmit;
-(void)fn_OnSubmitTapped;
-(void)handleShowAnswers;
-(void)Fn_disableAllDraggableSubjects;

@end
