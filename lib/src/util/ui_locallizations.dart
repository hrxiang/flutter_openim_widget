import 'package:flutter/material.dart';

class UILocalizations {
  UILocalizations._();

  static void set(Locale? locale) {
    _locale = locale ?? const Locale('zh');
  }

  static String _value({required String key}) =>
      _localizedValues[_locale.languageCode]![key] ?? key;

  static Locale _locale = const Locale('zh');

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'top': 'Stick to Top',
      'cancelTop': 'Remove from Top',
      'remove': 'Delete',
      'markRead': 'Mark as Read',
      "album": "Album",
      "camera": "Camera",
      "videoCall": "Video Call",
      "picture": "Picture",
      "video": "Video",
      "voice": "Voice",
      "location": "Location",
      "file": "File",
      "carte": "Contact Card",
      "voiceInput": "Voice Input",
      'haveRead': 'Have read',
      'groupHaveRead': '%s people have read',
      'unread': 'Unread',
      'groupUnread': '%s unread',
      'allRead': 'All read',
      'copy': 'Copy',
      "delete": "Delete",
      "forward": "Forward",
      "reply": "Quote",
      "revoke": "Revoke",
      "multiChoice": "Choice",
      "translation": "Translate",
      "download": "Download",
      "pressSpeak": "Hold to Talk",
      "releaseSend": "Release to send",
      "releaseCancel": "Release to cancel",
      "soundToWord": "Convert",
      "converting": "Converting...",
      "cancelVoiceSend": "Cancel",
      "confirmVoiceSend": "Send Voice",
      "convertFailTips": "Unable to recognize words",
      "confirm": "Confirm",
      "you": "You",
      "revokeAMsg": "revoke a message",
      "picLoadError": "Image failed to load",
      "fileSize": "File size: %s",
      "fileUnavailable": "The file has expired or has been cleaned up",
      "send": 'Send',
      "unsupportedMessage": '[Message types not supported]',
      "add": 'Add',
      "youMuted": 'You have been muted',
      "groupMuted": 'Enable group mute',
      "inBlacklist": 'The other party has been blacklisted',
      "playSpeed": 'Play speed',
      "cancel": 'Cancel',
      "groupNotice": 'Group Notice',
      "groupOwnerOrAdminRevokeAMsg": "%s revoked %s' message",
      "recentlyUsed": "Recently Used",
    },
    'zh': {
      'top': '置顶',
      'cancelTop': '取消置顶',
      'remove': '移除',
      'markRead': '标记为已读',
      "album": "相册",
      "camera": "拍摄",
      "videoCall": "视频通话",
      "picture": "图片",
      "video": "视频",
      "voice": "语音",
      "location": "位置",
      "file": "文件",
      "carte": "名片",
      "voiceInput": "语音输入",
      'haveRead': '已读',
      'groupHaveRead': '%s人已读',
      'unread': '未读',
      'groupUnread': '%s人未读',
      'allRead': '全部已读',
      'copy': '复制',
      "delete": "删除",
      "forward": "转发",
      "reply": "回复",
      "revoke": "撤回",
      "multiChoice": "多选",
      "translation": "翻译",
      "download": "下载",
      "pressSpeak": "按住说话",
      "releaseSend": "松开发送",
      "releaseCancel": "松开取消",
      "soundToWord": "转文字",
      "converting": "转换中...",
      "cancelVoiceSend": "取消",
      "confirmVoiceSend": "发送原语音",
      "convertFailTips": "未识别到文字",
      "confirm": "确定",
      "you": "你",
      "revokeAMsg": "撤回了一条消息",
      "picLoadError": "图片加载失败",
      "fileSize": "文件大小：%s",
      "fileUnavailable": "文件已过期或已被清理",
      "send": '发送',
      "unsupportedMessage": '[暂不支持的消息类型]',
      "add": '添加',
      "youMuted": '你已被禁言',
      "groupMuted": '已开启群禁言',
      "inBlacklist": '对方已被拉入黑名单',
      "playSpeed": '播放速度',
      "cancel": '取消',
      "groupNotice": '群公告',
      "groupOwnerOrAdminRevokeAMsg": "%s 撤回了 %s 的消息",
      "recentlyUsed": "最近使用",
    },
  };

  static String get top => _value(key: 'top');

  static String get cancelTop => _value(key: 'cancelTop');

  static String get remove => _value(key: 'remove');

  static String get markRead => _value(key: 'markRead');

  static String get album => _value(key: 'album');

  static String get camera => _value(key: 'camera');

  static String get videoCall => _value(key: 'videoCall');

  static String get picture => _value(key: 'picture');

  static String get video => _value(key: 'video');

  static String get voice => _value(key: 'voice');

  static String get location => _value(key: 'location');

  static String get file => _value(key: 'file');

  static String get carte => _value(key: 'carte');

  static String get voiceInput => _value(key: 'voiceInput');

  static String get haveRead => _value(key: 'haveRead');

  static String get unread => _value(key: 'unread');

  static String get groupHaveRead => _value(key: 'groupHaveRead');

  static String get groupUnread => _value(key: 'groupUnread');

  static String get allRead => _value(key: 'allRead');

  static String get copy => _value(key: 'copy');

  static String get delete => _value(key: 'delete');

  static String get forward => _value(key: 'forward');

  static String get reply => _value(key: 'reply');

  static String get revoke => _value(key: 'revoke');

  static String get multiChoice => _value(key: 'multiChoice');

  static String get translation => _value(key: 'translation');

  static String get download => _value(key: 'download');

  static String get pressSpeak => _value(key: 'pressSpeak');

  static String get releaseSend => _value(key: 'releaseSend');

  static String get releaseCancel => _value(key: 'releaseCancel');

  static String get soundToWord => _value(key: 'soundToWord');

  static String get converting => _value(key: 'converting');

  static String get cancelVoiceSend => _value(key: 'cancelVoiceSend');

  static String get confirmVoiceSend => _value(key: 'confirmVoiceSend');

  static String get convertFailTips => _value(key: 'convertFailTips');

  static String get confirm => _value(key: 'confirm');

  static String get you => _value(key: 'you');

  static String get revokeAMsg => _value(key: 'revokeAMsg');

  static String get picLoadError => _value(key: 'picLoadError');

  static String get fileSize => _value(key: 'fileSize');

  static String get fileUnavailable => _value(key: 'fileUnavailable');

  static String get acceptFriendHint => _value(key: 'acceptFriendHint');

  static String get addFriendHint => _value(key: 'addFriendHint');

  static String get send => _value(key: 'send');

  static String get unsupportedMessage => _value(key: 'unsupportedMessage');

  static String get youMuted => _value(key: 'youMuted');

  static String get groupMuted => _value(key: 'groupMuted');

  static String get add => _value(key: 'add');

  static String get inBlacklist => _value(key: 'inBlacklist');

  static String get playSpeed => _value(key: 'playSpeed');

  static String get cancel => _value(key: 'cancel');

  static String get groupNotice => _value(key: 'groupNotice');

  static String get groupOwnerOrAdminRevokeAMsg =>
      _value(key: 'groupOwnerOrAdminRevokeAMsg');

  static String get recentlyUsed => _value(key: 'recentlyUsed');
}
