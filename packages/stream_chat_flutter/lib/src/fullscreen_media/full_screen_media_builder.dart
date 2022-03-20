import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/fsm_stub.dart'
    if (dart.library.io) 'full_screen_media_desktop.dart' as desktop_fsm;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template fsmBuilder}
/// A wrapper widget for conditionally providing the proper FullScreenMedia
/// widget when writing an application that targets all available Flutter
/// platforms (Android, iOS, macOS, Windows, Linux, & Web).
///
/// This is required because:
/// * `package:video_player` and `package:chewie` do not support macOS, Windows,
/// & Linux, but _do_ support Android, iOS, & Web.
/// * `package:dart_vlc` _does_ support macOS, Windows, & Linux via FFI. This
/// has the unfortunate consequence of not supporting Web.
///
/// This widget makes use of dart's conditional imports to ensure that Stream's
/// desktop implementation of FullScreenMedia is not imported when building
/// applications that target web. Additionally, this widget ensures that
/// applications targeting mobile platforms do not build the version of
/// FullScreenMedia that targets desktop platforms (even though
/// `package:dart_vlc` technically supports iOS).
/// {@endtemplate}
class FullScreenMediaBuilder extends StatelessWidget {
  /// {@macro fsmBuilder}
  const FullScreenMediaBuilder({
    Key? key,
    required this.mediaAttachments,
    required this.message,
    required this.startIndex,
    required this.userName,
    this.onShowMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  }) : super(key: key);

  /// The url of the image
  final List<Attachment> mediaAttachments;

  /// Message where attachments are attached
  final Message message;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        return desktop_fsm.getFsm(
          message: message,
          mediaAttachments: mediaAttachments,
          startIndex: startIndex,
          userName: userName,
          autoplayVideos: autoplayVideos,
        );
      } else {
        return FullScreenMedia(
          mediaAttachments: mediaAttachments,
          message: message,
          startIndex: startIndex,
          userName: userName,
          onShowMessage: onShowMessage,
          attachmentActionsModalBuilder: attachmentActionsModalBuilder,
          autoplayVideos: autoplayVideos,
        );
      }
    } else {
      return FullScreenMedia(
        mediaAttachments: mediaAttachments,
        message: message,
        startIndex: startIndex,
        userName: userName,
        onShowMessage: onShowMessage,
        attachmentActionsModalBuilder: attachmentActionsModalBuilder,
        autoplayVideos: autoplayVideos,
      );
    }
  }
}
