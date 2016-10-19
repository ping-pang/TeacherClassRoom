//
//  JLHelpTableViewCell.m
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLHelpTableViewCell.h"

#define KLMargin          20.0
#define KLWidth           (Screen_Width -2*KLMargin)
#define KLHeight          22.0
#define IndicatorHeight    8.0
#define ScoreWidth        90.0
#define kLabelHeight    22.0f
#define kMargin          8.0f

@implementation JLHelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)setCellHeight{
    
    return (2.8*KLMargin + KLHeight +IndicatorHeight);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 只负责添加所有的子控件
        [self addAllSubViews];
    }
    return self;
}
- (void)addAllSubViews{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLMargin, 0, Screen_Width-KLMargin-40, 60)];
//    _titleLabel.backgroundColor=[UIColor yellowColor];
    _titleLabel.numberOfLines=0;
    [self.contentView addSubview:_titleLabel];
    
    _biaoImg = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width-40, 20, 10, 20)];
    self.biaoImg.image=[UIImage imageNamed:@"arrow_r_s.png"];
    [self.contentView addSubview:_biaoImg];
}
//+(double)caculateCellRowHeight:(NSString*)data {
//    
//    CGSize s = [JLHelpTableViewCell sizeForText:data withFont:[UIFont systemFontOfSize:15] contraint:Size(280.0, MAXFLOAT)];
//    
//    double dHeight = 0.0;
//    if (s.height > 44.0)
//        dHeight = s.height - 44.0;
//    
//    return dHeight + 44.0;
//}

-(void)cellWithTitle:(NSString *)title{
//    CGSize s = [JLHelpTableViewCell sizeForText:title withFont:self.titleLabel.font contraint:Size(self.titleLabel.frame.size.height, MAXFLOAT)];
//    if (s.height > self.titleLabel.frame.size.height) {
//        double dHeight = s.height - self.titleLabel.frame.size.height;
//        
//        CGRect f = self.titleLabel.frame;
//        f.size.height += dHeight;
//        self.titleLabel.frame = f;
//        
//        f = self.titleLabel.frame;
//        f.size.height += dHeight;
//        [self.titleLabel setFrame:f];
//        f = self.frame;
//        f.size.height += dHeight;
//        self.frame = f;
//    }
    self.titleLabel.text = title;


}
// 返回文本size
//+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font contraint:(CGSize)constraint
//{
//    CGSize size = CGSizeZero;
//    if (IOS7_OR_LATER)
//    {
//        size = [text boundingRectWithSize:constraint
//                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
//                                  context:nil].size;
//    }
//    else
//    {
//        size = [text sizeWithFont:font constrainedToSize:constraint
//                    lineBreakMode:NSLineBreakByWordWrapping];
//    }
//    return size;
//}
@end
