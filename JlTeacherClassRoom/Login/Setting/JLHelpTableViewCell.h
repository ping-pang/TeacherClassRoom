//
//  JLHelpTableViewCell.h
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLHelpTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel     * titleLabel;///<标题
@property(nonatomic,strong)UIImageView * biaoImg;///<三角

+(CGFloat)setCellHeight;
-(void)cellWithTitle:(NSString *)title;
//+(CGFloat)caculateCellRowHeight:(NSString*)data;

@end
