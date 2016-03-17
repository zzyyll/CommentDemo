//
//  AppUtils.h
//  DefineControlView
//
//  Created by 韩占禀 on 14/12/21.
//  Copyright (c) 2014年 hzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

@interface AppUtils : NSObject

+ (void)showAlert:(NSString *)_message; //自定义弹出框

+ (void)showTipWindow:(NSString *)str;

+ (void)showTipWindow:(UIImage *)bgImage andText:(NSString *)str; //自定义消息提示框

+ (void)jumpWebSite:(NSString *)url;

+ (void)callPhone:(NSString *)number;

+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

+ (CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width; //根据文字内容、字体大小、行宽返回文本高度

+ (CGSize)boundingRectWithSize:(CGSize)size addLable:(UIFont *)font andText:(NSString *)text; //根据文字内容、字体大小、行宽返回文本尺寸

+ (NSMutableAttributedString *)getTextColor:(NSString *)string andRang:(NSRange )range andColor:(UIColor *)color; //根据内容改变内容某些字体的颜色

+ (NSMutableAttributedString *)getTextFont:(NSString *)string andRang:(NSRange )range andFont:(UIFont *)font; //根据内容改变内容某些字体的大小

+ (NSMutableAttributedString *)getTextFontColor:(NSString *)string andRang:(NSRange )range andFont:(UIFont *)font andColor:(UIColor *)color; //根据内容改变内容某些字体的大小以及颜色

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
#pragma mark - 截取指定大小的图片
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

#pragma mark - 图片指定宽度按比例缩放
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

#pragma mark - 图片按比例缩放,size是你要把图显示到 多大区域 CGSizeMake(300, 140)
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

#pragma mark - 压缩、裁剪图片
+ (UIImage *)cutImage:(UIImage*)image andSize:(CGSize)size;

#pragma mark - 判断后台返回的字符串是否为空
+ (BOOL)isStringEmpty:(NSString *)str;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 * @brief 把字典转换成格式化的JSON格式的字符串
 * @param dic 字典
 * @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
