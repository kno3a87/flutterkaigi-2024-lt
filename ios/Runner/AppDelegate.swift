import Flutter
import UIKit

extension UIImage {
    func roundedCornerImage(withRadius radius: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)

            context.cgContext.addPath(path.cgPath)
            context.cgContext.clip()

            draw(in: rect)
        }
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
      
    guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else {
        fatalError("Cannot cast rootViewController as FlutterViewController")
    }

    let imageUtilChannel = FlutterMethodChannel(
      name: "utils_image",
      binaryMessenger: controller.binaryMessenger)
    imageUtilChannel.setMethodCallHandler {
      (call: FlutterMethodCall, result: @escaping FlutterResult) in

      switch call.method {

      case "crop_rgba":
        if let args = call.arguments as? [String: Any],
          let bytes = args["bytes"] as? FlutterStandardTypedData,
          let srcWidth = args["srcWidth"] as? Int,
          let srcHeight = args["srcHeight"] as? Int,
          let width = args["width"] as? Int,
          let height = args["height"] as? Int,
          let png = args["png"] as? Bool,
          let roundCorner = args["roundCorner"] as? Int,
          let top = args["top"] as? Int,
          let left = args["left"] as? Int
        {
          let colorSpace = CGColorSpaceCreateDeviceRGB()
          guard
            let context = CGContext(
              data: nil,
              width: srcWidth,
              height: srcHeight,
              bitsPerComponent: 8,
              bytesPerRow: 4 * srcWidth,
              space: colorSpace,
              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
          else {
            result(
              FlutterError(code: "error", message: "failed to to make CGContext", details: nil))
            return
          }
          bytes.data.withUnsafeBytes { unsafeBytes in
            if let baseAddress = unsafeBytes.baseAddress {
              context.data?.copyMemory(from: baseAddress, byteCount: bytes.data.count)
            }
          }
          guard let cgImage = context.makeImage() else {
            result(
              FlutterError(code: "bad_data", message: "failed to to make CGImage", details: nil))
            return
          }
          let image = UIImage(cgImage: cgImage)
          let rect = CGRect(x: left, y: top, width: width, height: height)
          if let imageRef: CGImage = image.cgImage?.cropping(to: rect) {
            let uiImage = UIImage(cgImage: imageRef)
            if !png {
              if let imageData: Data = uiImage.jpegData(compressionQuality: 1.0) {
                result(FlutterStandardTypedData(bytes: imageData))
              } else {
                result(FlutterError(code: "bad_data", message: "failed to crop", details: nil))
              }
            } else {
              if roundCorner > 0 {
                let roundedImage = uiImage.roundedCornerImage(withRadius: CGFloat(roundCorner))
                if let imageData: Data = roundedImage.pngData() {
                  result(FlutterStandardTypedData(bytes: imageData))
                } else {
                  result(FlutterError(code: "bad_data", message: "failed to crop", details: nil))
                }
              } else {
                if let imageData: Data = uiImage.pngData() {
                  result(FlutterStandardTypedData(bytes: imageData))
                } else {
                  result(FlutterError(code: "bad_data", message: "failed to crop", details: nil))
                }
              }
            }
          } else {
            result(FlutterError(code: "bad_data", message: "failed to crop", details: nil))
          }
        } else {
          result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
