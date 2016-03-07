//
//  MyTableCell.m
//  author Dy he
//  Grids
//

#import "MyTableCell.h"


@implementation MyTableCell

@synthesize hideLine;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		columns = [NSMutableArray arrayWithCapacity:5];
		hideLine=NO;
	}
	return self;
}


- (void)addColumn:(CGFloat)position {
	[columns addObject:[NSNumber numberWithFloat:position]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect { 
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// just match the color and size of the horizontal line
	float alpha=hideLine?0:1;
	CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, alpha); 
	CGContextSetLineWidth(ctx, 0.25);
	
	for (int i = 0; i < [columns count]; i++) {
		// get the position for the vertical line
		CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
		CGContextMoveToPoint(ctx, f, 0);
		CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
	}
	
	CGContextStrokePath(ctx);
	
	[super drawRect:rect];
}
@end
