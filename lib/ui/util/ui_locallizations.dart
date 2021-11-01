import 'package:flutter/material.dart';

class UILocalizations {
  const UILocalizations({
    this.locale = const Locale('zh'),
  });

  final Locale locale;

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
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
      'unread': '未读',
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
      'unread': '未读',
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
    },
  };

  String get top => _value(key: 'top');

  String get cancelTop => _value(key: 'cancelTop');

  String get remove => _value(key: 'remove');

  String get markRead => _value(key: 'markRead');

  String get album => _value(key: 'album');

  String get camera => _value(key: 'camera');

  String get videoCall => _value(key: 'videoCall');

  String get picture => _value(key: 'picture');

  String get video => _value(key: 'video');

  String get voice => _value(key: 'voice');

  String get location => _value(key: 'location');

  String get file => _value(key: 'file');

  String get carte => _value(key: 'carte');

  String get voiceInput => _value(key: 'voiceInput');

  String get haveRead => _value(key: 'haveRead');

  String get unread => _value(key: 'unread');

  String get copy => _value(key: 'copy');

  String get delete => _value(key: 'delete');

  String get forward => _value(key: 'forward');

  String get reply => _value(key: 'reply');

  String get revoke => _value(key: 'revoke');

  String get multiChoice => _value(key: 'multiChoice');

  String get translation => _value(key: 'translation');

  String get download => _value(key: 'download');

  String get pressSpeak => _value(key: 'pressSpeak');

  String get releaseSend => _value(key: 'releaseSend');

  String get releaseCancel => _value(key: 'releaseCancel');

  String get soundToWord => _value(key: 'soundToWord');

  String get converting => _value(key: 'converting');

  String get cancelVoiceSend => _value(key: 'cancelVoiceSend');

  String get confirmVoiceSend => _value(key: 'confirmVoiceSend');

  String get convertFailTips => _value(key: 'convertFailTips');

  String get confirm => _value(key: 'confirm');

  String get you => _value(key: 'you');

  String get revokeAMsg => _value(key: 'revokeAMsg');

  String get picLoadError => _value(key: 'picLoadError');

  String get fileSize => _value(key: 'fileSize');

  String get fileUnavailable => _value(key: 'fileUnavailable');

  String get acceptFriendHint => _value(key: 'acceptFriendHint');

  String get addFriendHint => _value(key: 'addFriendHint');

  String _value({required String key}) =>
      _localizedValues[locale.languageCode]![key] ?? key;
}
