//
//  ContentView.swift
//  MyCamera
//
//  Created by natsuko mizuno on 2024/03/19.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    //撮影した写真を格納する
    @State var captureImage: UIImage? = nil
    //撮影画面の表示状態を管理
    @State var isShowSheet = false
    //フォトライブラリーで選択した写真を保持するプロパティ
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if let captureImage {
                //撮影した写真を表示
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            
            
            Spacer()
            //「カメラを起動する」ボタン
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラ利用可")
                    isShowSheet.toggle()
                } else {
                    print("カメラ利用不可")
                }
            }, label: {
                Text("カメラを起動する")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            })
            .padding()
            .sheet(isPresented: $isShowSheet) {
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            
            
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                Text("フォトライブラリから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage) {
                if let photoPickerSelectedImage {
                    photoPickerSelectedImage.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data {
                                captureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            }
            
            
            
            if let captureImage {
                let shareImage = Image(uiImage: captureImage)
                ShareLink(item: shareImage, subject: nil, message: nil,
                          preview: SharePreview("Photo", image: shareImage)) {
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
