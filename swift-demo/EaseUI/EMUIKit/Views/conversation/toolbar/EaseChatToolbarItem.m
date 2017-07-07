
#import "EaseChatToolbarItem.h"

@implementation EaseChatToolbarItem

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View
{
    self = [super init];
    if (self) {
        _button = button;
        _button2View = button2View;
    }
    
    return self;
}

@end
