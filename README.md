# openim_ui_flutter

openim widget.


```
class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget _itemView(index, local) => ChatItemView(
        index: index,
        localizations: local,
        message: logic.messageList.elementAt(index),
        isSingleChat: logic.isSingleChat,
        clickSubject: logic.clickSubject,
        msgSendStatusSubject: logic.msgSendStatusSubject,
        msgSendProgressSubject: logic.msgSendProgressSubject,
        multiSelMode: logic.multiSelMode.value,
        multiList: logic.multiSelList.value,
        allAtMap: logic.atUserMappingMap,
        onMultiSelChanged: (checked) {
          logic.multiSelMsg(index, checked);
        },
        onTapCopyMenu: () {},
        onTapDelMenu: () {
          logic.deleteMsg(index);
        },
        onTapForwardMenu: () {
          logic.forward(index);
        },
        onTapReplyMenu: () {
          logic.setQuoteMsg(index);
        },
        onTapRevokeMenu: () {
          logic.revokeMsg(index);
        },
        onTapMultiMenu: () {
          logic.openMultiSelMode(index);
        },
        visibilityChange: (context, index, message, visible) {
          print('visible:$index $visible');
          logic.markC2CMessageAsRead(index, message, visible);
        },
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(index);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {},
        onTapRightAvatar: () {},
        onClickAtText: (v) {},
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return logic.exit();
      },
      child: ChatVoiceRecordLayout(
        builder: (bar, local) => Scaffold(
          backgroundColor: PageStyle.c_FFFFFF,
          body: Column(
            children: [
              Obx(() => EnterpriseTitleBar.chatTitle(
                    title: logic.name,
                    subTitle: 'xxx技术有限公司',
                    onClickCallBtn: () {},
                    onClickMoreBtn: () => logic.chatSetup(),
                    leftButton: logic.multiSelMode.value ? StrRes.cancel : null,
                    onClose: () => logic.exit(),
                  )),
              Expanded(
                child: Obx(() => TouchCloseSoftKeyboard(
                      onTouch: () => logic.closeToolbox(),
                      child: ListView.builder(
                        itemCount: logic.messageList.length,
                        padding: EdgeInsets.zero,
                        controller: logic.autoCtrl,
                        itemBuilder: (_, index) => Obx(() => AutoScrollTag(
                              key: ValueKey(index),
                              controller: logic.autoCtrl,
                              index: index,
                              child: _itemView(index, local),
                            )),
                      ),
                    )),
              ),
              Obx(() => ChatInputBoxView(
                    controller: logic.inputCtrl,
                    allAtMap: logic.atUserMappingMap,
                    toolbox: ChatToolsView(
                      localizations: local,
                      onTapAlbum: () => logic.onTapAlbum(),
                      onTapCamera: () => logic.onTapCamera(),
                      onTapCarte: () => logic.onTapCarte(),
                      onTapFile: () => logic.onTapFile(),
                      onTapLocation: () => logic.onTapLocation(),
                      onTapVideoCall: () => logic.call(),
                      onTapVoiceInput: () {},
                    ),
                    multiOpToolbox: ChatMultiSelToolbox(
                      onDelete: () => logic.mergeDelete(),
                      onMergeForward: () => logic.mergeForward(),
                    ),
                    onSubmitted: (v) => logic.sendTextMsg(),
                    forceCloseToolboxSub: logic.forceCloseToolbox,
                    voiceRecordBar: bar,
                    quoteContent: logic.quoteContent.value,
                    onClearQuote: () => logic.setQuoteMsg(-1),
                    multiMode: logic.multiSelMode.value,
                    focusNode: logic.focusNode,
                  )),
            ],
          ),
        ),
        onCompleted: (sec, path) {
          logic.sendVoice(duration: sec, path: path);
        },
      ),
    );
  }
}

```

| Widget               |                                                              |
| -------------------- | ------------------------------------------------------------ |
| ChatItemView         | The item of the chat page, including text, @text, picture, video, audio , file and custom item |
| ConversationItemView | The item of the conversation page                            |
| ChatInputBoxView     | The input box contains the processing of @ message           |
| ChatToolsView        |                                                              |
| TitleBar             |                                                              |
| UnreadCountView      |                                                              |


#### Dependencies packages

|                        |
| ---------------------- |
| rxdart                 |
| flutter_screenutil     |
| flutter_slidable       |
| cached_network_image   |
| path_provider          |
| photo_view             |
| flutter_image_compress |
| record                 |
| just_audio             |
| chewie                 |
| video_player           |
| lottie                 |
| permission_handler     |
| extended_text_field    |
| bubble                 |
