

#import <UIKit/UIKit.h>

typedef enum{
    EaseRecordViewTypeTouchDown,
    EaseRecordViewTypeTouchUpInside,
    EaseRecordViewTypeTouchUpOutside,
    EaseRecordViewTypeDragInside,
    EaseRecordViewTypeDragOutside,
}EaseRecordViewType;

@interface EaseRecordView : UIView

@property (nonatomic) NSArray *voiceMessageAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *upCancelText UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *loosenCancelText UI_APPEARANCE_SELECTOR;

-(void)recordButtonTouchDown;
-(void)recordButtonTouchUpInside;
-(void)recordButtonTouchUpOutside;
-(void)recordButtonDragInside;
-(void)recordButtonDragOutside;

@end
