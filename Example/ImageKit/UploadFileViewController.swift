//
//  UploadFileViewController.swift
//  ImageKit_Example
//
//  Created by Abhinav Dhiman on 26/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ImageKit

class UploadFileViewController: UIViewController {

    
    var fileUrlToBeUploaded: URL? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var filePreview: UIImageView!
    @IBOutlet weak var uploadFile: UIButton!
    
    @IBAction func OnClickSelect(_ sender: UIButton) {
        let document = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        document.delegate = self
        document.modalPresentationStyle = .formSheet
        self.present(document, animated: true, completion: nil)
    }
    
    @IBAction func OnClickUpload(_ sender: Any) {
        do{
            let filename = self.fileUrlToBeUploaded!.lastPathComponent
            let file = try NSData(contentsOf: self.fileUrlToBeUploaded!) as Data
            ImageKit.shared.uploader().upload(
                file: file,
                fileName: filename,
                useUniqueFilename: true,
                tags: ["demo","file"],
                folder: "/",
                signatureHeaders: ["x-test-header":"Test"],
                completion: { result in
                    switch result{
                        case .success(let uploadAPIResponse):
                            print(uploadAPIResponse)
                        case .failure(let error):
                            print(error)
                    }
            })
        } catch {
          print(error)
        }
        
    }
    
}

extension UploadFileViewController: UINavigationControllerDelegate, UIDocumentPickerDelegate{
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let file = urls.first {
            self.filePreview.image = UIImage.icon(forFileURL: file)
            self.uploadFile.isHidden = false
            self.fileUrlToBeUploaded = file
        }
    }
}


extension UIImage {
    public class func icon(forFileURL fileURL: URL) -> UIImage {
        return UIDocumentInteractionController(url: fileURL).icons.last!
    }
}
