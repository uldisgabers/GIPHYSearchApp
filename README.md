# GIPHY search app for iOS

This is an iOS app that uses [GIPHY API](https://developers.giphy.com/docs/api/) to show gifs and has the function to search gifs. Made using SwiftUI.

## Installation

1. Clone this repo
2. In the project folder `GIPHYSearchApp` create a new Swift file called `Secrets.swift`
3. Go to `https://developers.giphy.com/`, register your account and get the beta key to be able to use GIPHY API service
4. In the `Secrets.swift` file insert this code with your beta key

```bash
struct Secrets {
    static let apiKey = "YOUR_API_KEY"
}
```
