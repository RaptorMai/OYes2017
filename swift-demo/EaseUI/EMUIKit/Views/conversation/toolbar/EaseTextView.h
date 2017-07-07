
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DXTextViewInputViewType) {
    DXTextViewNormalInputType = 0,
    DXTextViewTextInputType,
    DXTextViewFaceInputType,
    DXTextViewShareMenuInputType,
};

@interface EaseTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderTextColor;

- (NSUInteger)numberOfLinesOfText;

+ (NSUInteger)maxCharactersPerLine;

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
