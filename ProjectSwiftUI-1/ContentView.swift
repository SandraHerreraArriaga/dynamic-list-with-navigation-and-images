//
//  ContentView.swift
//  ProjectSwiftUI-1
//
//  Created by Sandra Herrera on 25/06/19.
//  Copyright © 2019 Edison Effect. All rights reserved.
//
import Combine
import SwiftUI

class DataSource: BindableObject {
    let didChange = PassthroughSubject<Void,Never>()
    var pictures = [String]()
    
    init(){
        let fm = FileManager.default
        
        
        if let path = Bundle.main.resourcePath , let items  = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("image")
                {
                    pictures.append(item)
                }
            }
        }
        didChange.send(())
    }
    
}


struct DetailView : View {
    @State private var hidesNavigationBar = false
    var selectedImage : String
    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
            .tapAction {
                self.hidesNavigationBar.toggle()
        }
        
    }
}

struct ContentView : View {
    @ObjectBinding var dataSource = DataSource()
    
    var body: some View {
        NavigationView{
            List(dataSource.pictures.identified(by: \.self)) { picture in
                NavigationButton(destination: DetailView(selectedImage: picture), isDetail: true)
                {
                    Text(picture)
                }
                
            }.navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
