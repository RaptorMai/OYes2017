
#import <UIKit/UIKit.h>

@interface UIColor (Hyphenate)

+ (UIColor *)HIPrimaryColor;
+ (UIColor *)HIPrimaryRedColor;
+ (UIColor *)HIPrimaryLightColor;
+ (UIColor *)HIPrimaryDarkColor;
+ (UIColor *)HIPrimaryBgColor;
+ (UIColor *)HIGreenDarkColor;
+ (UIColor *)HIGreenLightColor;
+ (UIColor *)HIRedColor;
+ (UIColor *)HIGrayLightColor;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
