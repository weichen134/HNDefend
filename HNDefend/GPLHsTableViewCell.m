//
//  GPLHsTableViewCell.m
//  HNDefend
//
//  Created by 不贱不粘 on 16/1/20.
//  Copyright © 2016年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLHsTableViewCell.h"
#import "GPLProjectInfo.h"
@implementation GPLHsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setStatusModel:(GPLProjectInfo *)status
{
    NSString *aGateStr = [NSString stringWithFormat:@"1#%@",status.AIsOpen];
    NSString *bGateStr = [NSString stringWithFormat:@"2#%@",status.BIsOpen];
    NSString *cGateStr = [NSString stringWithFormat:@"3#%@",status.CIsOpen];
    NSString *dGateStr = [NSString stringWithFormat:@"4#%@",status.DIsOpen];
    
    NSString *aPumpStr = [NSString stringWithFormat:@"1#%@",status.AStarting];
    NSString *bPumpStr = [NSString stringWithFormat:@"2#%@",status.BStarting];
    NSString *cPumpStr = [NSString stringWithFormat:@"3#%@",status.CStarting];
    NSString *dPumpStr = [NSString stringWithFormat:@"4#%@",status.DStarting];
    
    NSString *aElectricStr = [NSString stringWithFormat:@"1#%@",status.AElectric];
    NSString *bElectricStr = [NSString stringWithFormat:@"2#%@",status.BElectric];
    NSString *cElectricStr = [NSString stringWithFormat:@"3#%@",status.CElectric];
    NSString *dElectricStr = [NSString stringWithFormat:@"4#%@",status.DElectric];
    
    
    int gateCount = [status.GateCount intValue];
    int pumpCount = [status.PumpCount intValue];
    

    //闸门
    if (gateCount == 1)
    {
        self.AIsOpenLabel.text = aGateStr;
        self.BIsOpenLabel.text = @"";
        self.CIsOpenLabel.text = @"";
        self.DIsOpenLabel.text = @"";
    }
    else if (gateCount == 2)
    {
        self.AIsOpenLabel.text = aGateStr;
        self.BIsOpenLabel.text = bGateStr;
        self.CIsOpenLabel.text = @"";
        self.DIsOpenLabel.text = @"";
    }
    else if (gateCount == 3)
    {
        self.AIsOpenLabel.text = aGateStr;
        self.BIsOpenLabel.text = bGateStr;
        self.CIsOpenLabel.text = cGateStr;
        self.DIsOpenLabel.text = @"";
    }
    else
    {
        self.AIsOpenLabel.text = aGateStr;
        self.BIsOpenLabel.text = bGateStr;
        self.CIsOpenLabel.text = cGateStr;
        self.DIsOpenLabel.text = dGateStr;
    }
    
    //水泵
    if (pumpCount == 1)
    {
        self.AStarting.text = aPumpStr;
        self.BStarting.text = @"";
        self.CStarting.text = @"";
        self.DStarting.text = @"";
        
    }
    else if (pumpCount == 2)
    {
        self.AStarting.text = aPumpStr;
        self.BStarting.text = bPumpStr;
        self.CStarting.text = @"";
        self.DStarting.text = @"";
    }
    else if (pumpCount == 3)
    {
        self.AStarting.text = aPumpStr;
        self.BStarting.text = bPumpStr;
        self.CStarting.text = cPumpStr;
        self.DStarting.text = @"";
    }
    else
    {
        self.AStarting.text = aPumpStr;
        self.BStarting.text = bPumpStr;
        self.CStarting.text = cPumpStr;
        self.DStarting.text = dPumpStr;
    }
    
    //泵机电流
    if (pumpCount == 1)
    {
        self.AElectric.text = aElectricStr;
        self.BElectric.text = @"";
        self.CElectric.text = @"";
        self.DElectric.text = @"";
    }
    else if (pumpCount == 2)
    {
        self.AElectric.text = aElectricStr;
        self.BElectric.text = bElectricStr;
        self.CElectric.text = @"";
        self.DElectric.text = @"";
    }
    else if (pumpCount == 3)
    {
        self.AElectric.text = aElectricStr;
        self.BElectric.text = bElectricStr;
        self.CElectric.text = cElectricStr;
        self.DElectric.text = @"";
    }
    else
    {
        self.AElectric.text = aElectricStr;
        self.BElectric.text = bElectricStr;
        self.CElectric.text = cElectricStr;
        self.DElectric.text = dElectricStr;
    }
    
    self.powerStateLabel.text = status.PowerState;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
