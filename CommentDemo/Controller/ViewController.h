//
//  ViewController.h
//  CommentDemo
//
//  Created by zhanbing han on 15/12/29.
//  Copyright © 2015年 北京与车行信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 * 商店id
 */
@property (nonatomic , copy)NSString *shop_id;

/**
 *  订单id
 */
@property (nonatomic , copy)NSString *order_id;


/**
 *  店铺名字
 */

@property (nonatomic , copy)NSString *shop_name;


@property (nonatomic , copy)void (^changeFlage)(NSInteger flags);

@end

