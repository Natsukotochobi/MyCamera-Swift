//
//  EffectView>swift.swift
//  MyCamera
//
//  Created by natsuko mizuno on 2024/04/11.
//

import SwiftUI

struct EffectView: View {
    
    //エフェクト編集画面(sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    //撮影した写真
    let captureImage: UIImage
    //表示する写真
    @State var showImage: UIImage?
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if let showImage {
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            //「エフェクト」ボタン
            Button {
                //アクション１
                let filterName = "CIPhotoEffectMono"
                let rotate = captureImage.imageOrientation
                let inputImage = CIImage(image: captureImage)
                
                //アクション２
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                effectFilter.setDefaults()
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                
                //アクション３
                let ciContext = CIContext(options: nil)
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                showImage = UIImage(
                cgImage: cgImage,
                scale: 1.0,
                orientation: rotate
                )
            } label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            //シェアボタン
            if let showImage {
                if let resizedImage = showImage.resized() {
                    let shareImage = Image(uiImage: resizedImage)
                    ShareLink(item: shareImage, subject: nil, message: nil,
                              preview: SharePreview("Photo", image: shareImage)) {
                        Text("シェア")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                    }
                              .padding()
                }
            }
            
            //閉じるボタン
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
        } //VStack
        .onAppear {
            showImage = captureImage
        }
        
    } //body
} //EffectView

#Preview {
    EffectView(
        isShowSheet: .constant(true),
        captureImage: UIImage(named: "preview_use")!
    )
}
