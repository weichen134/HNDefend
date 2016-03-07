//
//  MyTableCell.h
//  author Dy he
//  Grids
//

#import <UIKit/UIKit.h>


@interface MyTableCell : UITableViewCell {
	
	NSMutableArray *columns;
	bool hideLine;
}
@property(assign) bool hideLine;
- (void)addColumn:(CGFloat)position;

@end
