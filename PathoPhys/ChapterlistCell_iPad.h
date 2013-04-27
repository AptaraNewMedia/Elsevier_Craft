//
//  ChapterlistCell_iPad.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 08/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterlistCell_iPad : UITableViewCell
{
    IBOutlet UIImageView *imgTableCellBG;
    IBOutlet UILabel *lblChapterName;
    IBOutlet UIImageView *imgDisclosure;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgTableCellBG;
@property (nonatomic, retain) IBOutlet UILabel *lblChapterName;

@property (nonatomic, retain) IBOutlet UIImageView *imgDisclosure;

@end
