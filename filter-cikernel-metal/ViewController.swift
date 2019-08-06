import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputImage = UIImage(named: "lena.png")!
        print("lena size : \(inputImage.size)")
        imageView.image = inputImage
        print("imageView size : \(imageView.bounds.size)")
        print("imageView.image : \(imageView.image!.size)")
        imageView.contentMode = .scaleToFill
        let ciInput = CIImage(image: inputImage)!
        
        guard let path =  Bundle.main.path(forResource: "default", ofType: "metallib") else {
            print("path was not found")
            return
        }
        print("path: \(path)")
        
        url = URL(fileURLWithPath: path)
        print("url: \(path)")
        
        /*
         guard url != nil else {
         print("url is nil")
         return
         }*/
        
        let start = Date()
        guard let grayImage = gray(ciInput) else { return }
        let interval = Date().timeIntervalSince(start) // ベンチマークテスト
        print("処理時間 : \(interval)")
        
        
        imageView.image = UIImage(ciImage: grayImage)
        
    }
    
    // フィルタ（CIKernelで実装）
    func gray(_ input: CIImage) -> CIImage? {
        // .metalファイル -> data型
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to get data")
        }
        // CIKernel生成
        let kernel: CIKernel?
        do {
            kernel = try CIColorKernel(functionName: "grayscale", fromMetalLibraryData: data)
        } catch let error {
            print("\(error)")
            return nil
        }
        // ROI（注目領域）をCGRectで返す
        let roiCallback: CIKernelROICallback = { (index: Int32, rect: CGRect) -> CGRect in
            // 半径1ピクセルの領域をサンプリングする（半径1ピクセルで効果を適用する）
            return rect.insetBy(dx: 1, dy: 1)
        }
        let outputImage = kernel!.apply(extent: input.extent, roiCallback: roiCallback, arguments: [input])
        return outputImage
    }
}

