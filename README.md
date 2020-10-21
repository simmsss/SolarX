# SolarX

**HackNC 2020 - Best Hack for Sustainability, Wolfram Award, and Top 20 Hack**

Code snippets and supporting documentation for the SolarX project by The Mistfits for HackNC

## About SolarX

![App Screenshots](https://github.com/simmsss/SolarX/blob/main/UI%20Elements/Screenshots/1.png)

### VIDEO WALKTHROUGHS:

For a detailed video explanation with voice-over, click [here](https://www.youtube.com/watch?v=Ul3U97mjzk0).

### Inspiration

Renewable energy is the future. It has to be, or else there won’t be a future at all. While most of the world profits off renewable energy in attempts to attain carbon neutrality, a major part of rural India still remains oblivious to the perks bestowed by such alternatives. In a country of open pastures and green plains with up to 2000+ hour of sunshine per year, it is devastating to see most rural dwellers still living off archaic energy sources like forest wood. 

### What is SolarX?

Our proposed solution- SolarX is a mobile application that enables people in rural India to get on the solar grid for as little time, effort and money as possible. 

SolarX uses Augmented Reality and Machine Learning to deliver a platform for users to know solar installation costs and get an estimate on their potential electricity bill savings based on the solar irradiance at their geographical location and their roof area. To help villages get on the solar grid, the app connects users with government-provided subsidies for their region and links them with installation providers.

**What gives us an edge over others?**

While getting smartphones to our target audience is easy, assuming a stable round-the-clock Internet connection, might not be a wise assumption to make, and hence, all core features of SolarX are available offline, which would work wonders for us considering the fact that for all kinds of mobile users in India, whether in rural or urban areas, young or old, the price elasticity of demand for data usage is quite high, i.e. the amount of data they use is very sensitive to the price they have to pay for it. 

### Technical Stack

SolarX is delivered as an iOS and iPadOS application built using Swift. Some key first-party libraries used are CoreData, ARKit and CoreML. All processing and data tasks are handled on-device.

### Challenges

To remove dependence on third-party providers, we had to implement the mathematical formula for solar irradiance in native Swift code.

### Accomplishments

1.	Augmented Reality implementation
2.	Offline Capabilities and Data Privacy features of the application
3.	The elegant UI and UX built in under two hours.

### What we learned

1.	Spatial Recognition
2.	CreateML
3.	Perseverance 

### Market fit

The scope of digital services has significantly expanded in recent years and the ongoing coronavirus pandemic has generated a greater need for digital accessibility. Thereby, having all the services of SolarX available offline would ensure an effective outreach amongst the masses. 

The pandemic has also changed the financial status and spending decisions of people around the globe, and it’s a well-known fact, that Indians have the highest instance of saving and investment, therefore providing them with a service that gives an estimate on potential electricity bill savings after rooftop solar installations would be a profitable deal in the long run. 

### Future Scope 

1.	As the immediate next step, we plan on integrating Smart Home device monitoring in the app to allow Urban users to manage their Solar Energy in a better way. 
2.	To improve our services for the rural audience, we plan to collaborate with clusters of local suppliers to establish a marketplace for solar installations and services catered to the needs of the user. 
3.	The final step in the foreseeable future would be to allow the rural population to generate and share their personal solar reserves with other villagers and monitor the expenses and billing using the app. 

### Requirements

#### Hardware

* MacBook, Mac Mini, iMac, Mac Pro or any other variant running macOS 10.15.4 (Catalina) or later.
* Atleast 4GB of RAM recommended (For running on Simulator)
* An iPhone or iPad running iOS/iPadOS 14.0 or later. (For running on physical device)

#### Software

* Xcode version 12.0
* Xcode Command Line Tools
* CocoaPods

#### Instructions

Clone the GitHub repo on your local machine. Navigate to the project folder in the terminal and run `pod install` to install dependencies. Open the workspace in Xcode, configure the profiles and hit run for the simulator to load up. 

Made with ❤️ by [Simran](https://simmsss.github.io/) and [Utkarsh](https://skhiearth.github.io/)
