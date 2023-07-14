#  GemID: AI Powered Gem Classification V2

GemID takes advantage of Apple's CreateML and CoreML frameworks for machine learning. I trained a model to recognize over 
87 different gemstones provided by Daria Chemkaeva through Kaggle. This dataset can be found at https://www.kaggle.com/datasets/lsind18/gemstones-images . Some modifications were made to the dataset by me.

## Features added in V2
- Added Firestore database support.
- ML model now provides a brief description of the identified gem.
- Small UI changes for displaying database info

## Running the project

1. Clone the repo to your desktop and open through Xcode. 
2. Connect an iPhone to your machine via lightning cable.
3. Select your iphone as exe destination. (Developer mode must be on)
4. Run GemID on your device.

\* Attempting to upload an image for analysis will result in a directory error from CoreML and the prediction will not be given. That is why I am recommending running the application on a physical, rather than virtual, Iphone. \*

## Additional comments

This project was made for CS4480, and AI course taught at CSU Stanislaus by Dr. Koh. I may or may not bring this application to the app store one day. The data use for training this model was not very large resulting in an accuracy score of 59%. Gem classification goes beyond looking at pretty rocks. Complex tools and analysis are used for this job and simply cannot be reliably implemented in a phone application. This project was simply for fun, I would not want to release an AI model with such a low accuracy score to the public. If I ever decide to release this app on the App Store, it will be for familiarizing myself with that process. 
