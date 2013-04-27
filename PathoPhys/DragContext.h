//
//  Created by jve on 4/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface DragContext : NSObject
@property(nonatomic, retain, readonly) UIView *draggedView;
@property(nonatomic, retain) UIView *originalView;
@property (nonatomic)  CGPoint firstPosition;
@property (nonatomic, retain)  UIView *firstView;



- (id)initWithDraggedView:(UIView *)draggedView;

- (void)snapToOriginalPosition;
- (void)snapToFirstPositionwithDraggedView:(UIView *)dragdView withFirstPosition:(CGPoint)firstpos WithView:(UIView *)firstView;
@end