

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EaseChatToolbarItem : NSObject

@property (strong, nonatomic, readonly) UIButton *button;

@property (strong, nonatomic) UIView *button2View;

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View;

@end
