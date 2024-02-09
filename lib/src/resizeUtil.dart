import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' show Platform;

class ResizeUtil {
  /// Default size for device
  static const Size defaultSize = Size(360, 690);

  /// [Size] of the device
  static late Size ui;

  /// Boolean to indicate text scaling

  /// Screen width of the device
  static late double _screenWidth;

  /// Screen height of the device
  static late double _screenHeight;

  /// Base size used to calculate rem [ResizeUtil.rem]
  static late double _base;

  /// Current Orientation of the device
  static late Orientation _orientation;

  /// [ResizeUtil.deviceType]
  static late DeviceType _deviceType;

  /// Initializing [ResizeUtil]
  void init(
    BoxConstraints constraints,
    Orientation orientation, {
    double base = 16.0,
    Size size = defaultSize,
  }) {
    _orientation = orientation;
    ui = size;

    /// Sets the device _screenWidth and _screenHeight
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    /// Sets the device type
    if (kIsWeb) {
      _deviceType = DeviceType.Web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      /// Based on the device's orientation and size _deviceType will be assigned
      if ((_orientation == Orientation.portrait && _screenWidth < 600) ||
          (_orientation == Orientation.landscape && _screenHeight < 600)) {
        _deviceType = DeviceType.Mobile;
      } else {
        _deviceType = DeviceType.Tablet;
      }
    } else if (Platform.isMacOS) {
      _deviceType = DeviceType.Mac;
    } else if (Platform.isWindows) {
      _deviceType = DeviceType.Windows;
    } else if (Platform.isLinux) {
      _deviceType = DeviceType.Linux;
    } else if (Platform.isFuchsia) {
      _deviceType = DeviceType.Fuchsia;
    }

    _base = base;
  }

  /// Gives the screen width of the device
  double get screenWidth => _screenWidth;

  /// Gives the screen height of the device
  double get screenHeight => _screenHeight;

  /// Gives the scale width for the device
  double get scaleW => _screenWidth / ui.width;

  /// Gives the scale height for the device
  double get scaleH => _screenHeight / ui.height;

  /// Gives the scale factor for the device
  double get scale => max(scaleW, scaleH);

  /// Gives the responsive height
  double height(num input) => input * scaleH;

  /// Gives the responsive width
  double width(num input) => input * scaleW;

  /// caculates the view height for the given input
  double viewHeight(num input) => input * (_screenHeight / 100);

  /// calculates the view width for the given input
  double viewWidth(num input) => input * (_screenWidth / 100);

  /// Returns font size in rem based on the input and base size
  double rem(num input) => input * _base;

  /// Gives the font size in scalarPixels based on the input
  /// If [allowtextScaling] is set true it will returns a scalable font size
  /// If [allowtextScaling] is set false it will returns a non scalable font size
  double scalarPixel(num input) => input * scale;

  /// Return the radius for rounded corners
  double radius(num input) => input * scale;

  /// Gives the current orientation of the device
  Orientation get orientation => _orientation;

  /// Gives the current device type [ResizeUtil.deviceType]
  DeviceType get deviceType => _deviceType;

  /// Return maximum value between [ResizeUtil.viewWidth] and [ResizeUtil.viewHeight]
  double maxViewPort(num input) {
    double vH = viewHeight(input);
    double vW = viewWidth(input);
    return max(vH, vW);
  }
}

/// Enum to store device type
enum DeviceType {
  Mobile,
  Tablet,
  Web,
  Mac,
  Windows,
  Linux,
  Fuchsia,
}
