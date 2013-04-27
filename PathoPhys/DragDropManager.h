//
//  Created by jve on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class DragContext;


@interface DragDropManager : NSObject
- (id)initWithDragSubjects:(NSArray *)dragSubjects andDropAreas:(NSArray *)dropAreas;

- (void)dragging:(id)sender;


@property(nonatomic, retain) DragContext *dragContext;
@property(nonatomic, retain) DragContext *dragContextSwap;
@property(nonatomic, retain, readonly) NSArray *dropAreas;


@end