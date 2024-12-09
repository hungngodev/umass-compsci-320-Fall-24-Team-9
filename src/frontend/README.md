Here’s a polished and visually engaging version of your README:

---

# 🌍 Travel Buddy Finder

An innovative application designed to suggest travel destinations for groups of friends from various regions, helping them plan trips effortlessly.

---

## ✨ Features

- **Personalized Suggestions**: Leveraging OpenAI API to recommend destinations tailored to group preferences.
- **Cross-Platform App**: Built with Flutter for a seamless experience on iOS and Android.
- **Interactive Backend**: Powered by Django for robust and scalable backend support.

---

## 🚀 Getting Started

Follow these steps to set up and run the application locally:

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Open the iOS Simulator:
   ```bash
   open -a Simulator
   ```
4. Run the Flutter app:
   ```bash
   flutter run
   ```

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Remove the existing database if it exists:
   ```bash
   rm db.sqlite3
   ```
3. Apply database migrations:
   ```bash
   python3 manage.py makemigrations
   python3 manage.py migrate
   ```
4. Load predefined activities into the database:
   ```bash
   python3 manage.py load_activities
   ```
5. Start the development server:
   ```bash
   python3 manage.py runserver
   ```

---

### Loading backend API JSON files

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Type and enter this to run apiEventData:
   ```bash
   python3 apiEventData.py

   ```
3. Then go to link indicated in terminal:
4. Same goes for apiHotelsData and apiRESTData.

---

## 🛠️ Technologies Used

- **Frontend**: Flutter
- **Backend**: Django
- **API Integration**: OpenAI API, SerpApi, Yelp Fusion API

---

## 🎉 Ready to Plan Your Next Adventure?

Start the app and let **Travel Buddy Finder** recommend the perfect destination for you and your friends!

---

Feel free to add badges, images, or additional links if desired to make it even more engaging!
