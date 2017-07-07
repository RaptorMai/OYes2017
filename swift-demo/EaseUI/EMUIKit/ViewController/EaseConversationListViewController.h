
#import "EaseRefreshTableViewController.h"
#import "EaseConversationModel.h"
#import "EaseConversationCell.h"
#import <Hyphenate/Hyphenate.h>

typedef NS_ENUM(int, DXDeleteConvesationType) {
    DXDeleteConvesationOnly,
    DXDeleteConvesationWithMessages,
};

@class EaseConversationListViewController;

@protocol EaseConversationListViewControllerDelegate <NSObject>

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel;

@optional

@end

@protocol EaseConversationListViewControllerDataSource <NSObject>

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                        modelForConversation:(EMConversation *)conversation;

@optional

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel;

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel;

@end


@interface EaseConversationListViewController : EaseRefreshTableViewController <EMChatManagerDelegate,EMGroupManagerDelegate>

@property (weak, nonatomic) id<EaseConversationListViewControllerDelegate> delegate;
@property (weak, nonatomic) id<EaseConversationListViewControllerDataSource> dataSource;

- (void)tableViewDidTriggerHeaderRefresh;

- (void)refreshAndSortView;

@end
