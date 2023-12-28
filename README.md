# NiceWeather
## _Weather Utility App_
NiceWeather is a weather application built using SwiftUI framework that retrieves and displays weather information through the [OpenWeather](https://openweathermap.org/) API. The app supports the following features:
- Displaying the current weather conditions for the user's current location.
- Weather forecast for the next five days.
- Searching for other cities to get weather conditions and forecasts.

# Screenshots
![screenshots](https://github.com/connniela/niceweather/blob/main/screenshots/screenshot.png)

# Requirements
- iOS 16.0+
- Xcode 15.0+
- Swift 4.0+
- [OpenWeather](https://openweathermap.org/) API Key
#### Replace APIKey with your OpenWeather API Key
```
struct API {
    static let apiKey = "APIKey"
    static let baseUrl = "https://api.openweathermap.org"
    static let iconUrl = "https://openweathermap.org"
}
```
# Features
- #### Display Current Weather Conditions
    Concisely shows real-time weather conditions for the current location, including temperature, wind speed, humidity, sunset, sunrise, and more.
- #### Five-Day Weather Forecast
    Visualizes the weather forecast for the next five days through lists.
- #### Search for Other Cities
    Provides a search feature allowing users to input city names and retrieve weather conditions and forecasts for the specified city.

# Architecture
- SwiftUI
- MVVM
- Combine

# License
This project is licensed under the MIT License. See [LICENSE](https://github.com/connniela/niceweather/blob/main/LICENSE "LICENSE") for details.
