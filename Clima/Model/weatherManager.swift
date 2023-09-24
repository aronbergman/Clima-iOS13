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
        let urlForFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)"
        
        print(urlForFetch)
    }
}
