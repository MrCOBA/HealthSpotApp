import UIKit

extension UIImageView {

    public func imageFromServerURL(_ url: URL?, placeholder: UIImage?, completion: @escaping (() -> Void)) {
        image = nil

        if let url = url {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    logWarning(message: "Error loading images from URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeholder
                        completion()
                    }
                    return
                }

                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                    completion()
                }
            }).resume()
        }
    }

}
