//
//  FlashCardsViewController.h
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashCardsViewController : UIViewController
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UIView *viewLargeImage;
    IBOutlet UIScrollView *scrollGallery;
    IBOutlet UIButton *btnLargePrev;
    IBOutlet UIButton *btnLargeNext;
    IBOutlet UIButton *btnPrev;
    IBOutlet UIButton *btnNext;
    IBOutlet UIImageView *imgAlphabetBg;
    IBOutlet UITableView *tblAlphabet;
    IBOutlet UITableView *tblChapter;
    IBOutlet UILabel *lblChapterList;
    IBOutlet UIView *view_chapterTbl;
    IBOutlet UISegmentedControl *segControllor;
    IBOutlet UIImageView *img_shado;
    IBOutlet UIButton *btn_popupRemove;
    
    IBOutlet UIView *viewSegment;
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UIScrollView *scrollViewMiddle;
    
    IBOutlet UIImageView *img_segment;
    IBOutlet UIButton *Bn_Alphabet;
    IBOutlet UIButton *Bn_Shuffle;
    IBOutlet UIButton *Bn_ByChapter;
}

- (IBAction)Bn_Back_Tapped:(id)sender;
- (void) disableAllButtons;
@end
