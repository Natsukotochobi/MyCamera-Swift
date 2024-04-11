//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by natsuko mizuno on 2024/03/19.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    //撮影画面の表示状態を管理
    @Binding var isShowSheet: Bool
    //撮影した写真を格納する
    @Binding var captureImage: UIImage?
    
    //Coordinatorクラスを作成
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        //ImagePickerView型の定数を用意
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        //撮影が終わった時に呼ばれるdelegateメソッド（必ず必要）
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                                   [UIImagePickerController.InfoKey: Any]) {
            //撮影した写真をcaptureImageに保存
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            
            //sheetを閉じる
            parent.isShowSheet.toggle()
        }
        
        //キャンセルボタンが選択された時に呼ばれるdelegateメソッド（必ず必要）
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //sheetを閉じる
            parent.isShowSheet.toggle()
        }
    }
    
    //Coordinator必須メソッド・インスタンスの生成
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //UIViewControllerRepresentable必須メソッド1・Viewの生成
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let myImagePickerController = UIImagePickerController()
        
        myImagePickerController.sourceType = .camera
        
        myImagePickerController.delegate = context.coordinator
        
        return myImagePickerController
    }
    
    //UIViewControllerRepresentable必須メソッド2・Viewの更新
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //処理なし
    }
}

