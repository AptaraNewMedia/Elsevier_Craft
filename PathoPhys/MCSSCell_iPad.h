//
//  ChapterlistCell_iPad.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 08/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCSSCell_iPad : UITableViewCell
{
    IBOutlet UIImageView *imgTableCellBG;
    IBOutlet UILabel *lblOptionName;
    IBOutlet UIImageView *imgAns;
    IBOutlet UILabel *lblAlphabet;
    IBOutlet UIButton *btnFeedback;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgTableCellBG;
@property (nonatomic, retain) IBOutlet UILabel *lblOptionName;
@property (nonatomic, retain) IBOutlet UIImageView *imgAns;
@property (nonatomic, retain) IBOutlet UILabel *lblAlphabet;
@property (nonatomic, retain) IBOutlet UIButton *btnFeedback;
@property (nonatomic, retain) NSString *strFeedback;
@end
