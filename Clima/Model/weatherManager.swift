//
//  weatherManager.swift
//  Clima
//
//  Created by Aron I. Bergman on 23.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let apiKey = "bb6604b1269d65e5e050234364f52d9b"
    
    func fetchWeather(cityName: String) {
        let city = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlForFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        
        
        performRequest(urlString: urlForFetch)
    }
    
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
                    self.parseJSON(weatherData: safeData)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName)
            
        } catch {
            print(error)
        }
    }

}
