//
//  GPLProjectCell.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLProjectCell.h"

@implementation GPLProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHeight:(NSString *)height{
    int h = [height integerValue];
    CGRect nameFrame = self.nameLabel.frame;
    CGRect timeFrame = self.timeLabel.frame;
    CGRect waterLevelFrame = self.waterLevel.frame;
    CGRect timeBgFrame = self.timeBg.frame;
    CGRect wrongBgFrame = self.wrongBg.frame;
    nameFrame.origin.y += h/2.0;
    timeFrame.origin.y += h/2.0;
    waterLevelFrame.size.height += h;
    timeBgFrame.origin.y += h/2.0;
    wrongBgFrame.origin.y += h/2.0;
    //设置
    self.nameLabel.frame = nameFrame;
    self.timeLabel.frame = timeFrame;
    self.timeBg.frame = timeBgFrame;
    self.waterLevel.frame = waterLevelFrame;
    self.wrongBg.frame = wrongBgFrame;
}

@end
