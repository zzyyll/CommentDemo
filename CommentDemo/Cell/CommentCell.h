//
//  CommentCell.h
//  XWDC
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 hcb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count

@interface CommentCell : UICollectionViewCell
@property (nonatomic , retain)UIImageView *imageView;
@property (nonatomic , retain) UIButton *cancelBtn;
@end
