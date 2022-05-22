//
//  ContentView.swift
//  NewsApp
//
//  Created by Berke Sarıtaş on 21.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var titleText : String = "Deneme title"
    @State var descText : String = "Deneme desc"
    @State var index = -1
    @State var imageString : String = ""    
    let urlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=c92e234b4f294ec8a3fae76a85457733"
    
    func getData(from url : String) {
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {
            data , response , error in
            
            guard let data = data , error == nil else{
                print("something went worng")
                return
            }
            
            var result : Response?
            do {
                result =  try JSONDecoder().decode(Response.self, from: data)
            } catch  {
                print(error.localizedDescription)
            }
            
            guard let json = result else {
                return
            }
            
       
            print(json.articles[index].title)
            
            descText = json.articles[index].description!
            titleText = json.articles[index].title
            if json.articles[index].urlToImage != nil {
                imageString = json.articles[index].urlToImage!
            }

            
        }).resume()
    }
    
    struct Response : Codable  {
        let status : String
        let totalResults : Int
        var articles : [source]
        }
    
    struct source : Codable {
        
        let title : String
        let author : String?
        let description : String?
        let url : String?
        let urlToImage : String?
        let publishedAt : String?
        let content : String?
        
    }
    

    
    var body: some View {
        
        VStack{
            
            Text(titleText)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            
            AsyncImage(
                url: URL(string: imageString),
                content: { image in
                image.resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(35)
                .frame(maxWidth: 400, maxHeight: 200)
                },
                placeholder: {
                    ProgressView()
                            }
                        )
            .padding()
            
            Text(descText)
                .font(.subheadline)
                .padding()
            
            HStack {
                Button("Geri"){
                    
                    index = index - 1
                    getData(from: urlString)

                }
                .frame(width: 100,
                       height: 40,
                       alignment: Alignment.center)
                .background(Color.blue)
                .cornerRadius(40)
            .foregroundColor(Color.white)
            .padding()
            
            Button("İleri"){
                
                index = index + 1
                getData(from: urlString)

                }
                .frame(width: 100,
                       height: 40,
                       alignment: Alignment.center)
                .background(Color.blue)
                .cornerRadius(40)
            .foregroundColor(Color.white)
            .padding()
            
            }
            
            
        }
        
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
