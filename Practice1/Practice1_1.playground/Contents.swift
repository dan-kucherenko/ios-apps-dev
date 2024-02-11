import UIKit

struct HoroscopeResponse: Codable {
    let date: String
    let horoscope: String
    let icon: String
    let id: Int
    let sign: String
}

func getDataCallback() {
    let endPoint = "https://newastro.vercel.app/aries"
    guard let url = URL(string: endPoint) else {
        print("Error in creating URL")
        return
    }
    
    let dataTask = URLSession.shared.dataTask(with: url, completionHandler:
                                                {
        data, _, error in
        if let error = error {
            print(error.localizedDescription)
        }
        guard let data else {print("Data is nil"); return}
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(HoroscopeResponse.self, from: data)
            print(response)
        } catch {
            print("Error, while decoding the response")
        }
    })
    dataTask.resume()
}

getDataCallback()

func getDataAsync() async {
    let endPoint = "https://newastro.vercel.app/aries"
    guard let url = URL(string: endPoint) else {
        print("Error in creating URL")
        return
    }
    
    var data: Data?
    do {
        let (apiData, _) = try await URLSession.shared.data(from: url)
        data = apiData
    } catch {
        print("Error getting the data from api")
    }
    
    guard let data else {print("Data is nil"); return}
    
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(HoroscopeResponse.self, from: data)
        print(response)
    } catch {
        print("Error, while decoding the response")
    }
}

func getDataAsyncWithData(data: String) {
    let endPoint = "https://newastro.vercel.app/aries"
    guard let url = URL(string: endPoint) else {
        print("Error in creating URL")
        return
    }
    let component = URLComponents(url: url, resolvingAgainstBaseURL: true)
    component?.url?.appending(queryItems: <#T##[Foundation.URLQueryItem]#>) // key - value in this function
}

Task {
    await getDataAsync()
}
