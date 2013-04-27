//
//  CustomCell.h
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imgview_cellpatch;

@property (nonatomic, retain) IBOutlet UILabel *lbl_serionNo;
@property (nonatomic, retain) IBOutlet UILabel *lbl_name;

@property (nonatomic, retain) IBOutlet UILabel *lbl_score;
@property (nonatomic, retain) IBOutlet UILabel *lbl_date;

@property (nonatomic, retain) IBOutlet UIButton *btn_share;


@end
