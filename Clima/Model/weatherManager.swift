//
//  weatherManager.swift
//  Clima
//
//  Created by Aron I. Bergman on 23.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager {
    let apiKey = "bb6604b1269d65e5e050234364f52d9b"
    
    func fetchWeather(cityName: String) {
        let city = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlForFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        
        
        performRequest(urlString: urlForFetch)
    }
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create session with configuration
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print("❌: \(error!)")
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
                        
                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
     return weather
            
        } catch {
            print(error)
            return nil
        }
    }

}
