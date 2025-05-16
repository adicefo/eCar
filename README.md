# 🚗 eCar

**A project for purposes of the _"Razvoj Softvera II"_ subject.**

---

## 🔐 Credentials

### 👨‍💼 Admin (Desktop App):
- **Email:** `admin@edu.fit.ba`  
- **Password:** `test`

### 👤 Client (Mobile App):
- **Email:** `client1@edu.fit.ba`  
- **Password:** `test`  
- ℹ️ *Same credentials for `client2`,`client3` and `client4`.*

### 🚘 Driver (Mobile App):
- **Email:** `driver1@edu.fit.ba`  
- **Password:** `test`  
- ℹ️ *Same credentials for `driver2` , `driver3` and `driver4`.*

---

## ⚙️ IMPORTANT! Emulator Setup for Google Navigation SDK

This app uses the **Google Navigation SDK**.  
To run the app properly on an **emulator**, follow these requirements:

- ✅ Use image with **API 35**
- ✅ Enable **Google Play Services**
- ✅ Enable **Wi-Fi**
- ✅ Enable **Location**



---

## 🧪 Steps for Testing Main App Functionality

Follow these steps to test the **main app drive functionality**:

1. 🚘 **Login as a Driver** using the provided credentials  
   - Tap the **car icon** in the app bar → **Assign car**
2. 👤 **Login as a Client**  
   - Navigate to **Order** → Choose a car → **Send drive request**
3. 🔄 **Switch back to Driver**  
   - Go to **Requests** → **Accept Request**
4. 🏁 **Start the Drive**  
   - Open **Drives** → Tap **Start Drive**

---

### 🧭 Test Navigation SDK

Test the **Google Navigation SDK** functionality using the following steps:

1. 🗺️ Tap **"Add Source Point"** and then **"Add Destination Point"**
2. 🚦 Tap the **"Start Guidance"** button to begin navigation
3. 🛑 Once finished, tap **"Stop Guidance"**
4. ✅ Tap **"Finish Drive"** to complete the drive  
   - You’ll then see the **total price** and a message indicating if the **user has already paid**


> ⚠️ **NOTE: If you test the mobile app on an emulator, use a location in the _United States of America_**  
> **because the default location of the emulator is somewhere near _San Francisco_!** 🌍
---

## 🖥️ Desktop Report Testing

> 🔎 **NOTE:** If you are testing the **Review** section of the report in the desktop app, please select **April 2025** to properly test this functionality.
---

## 🐳 Docker

To run the full system using Docker:

`docker-compose up --build`

⚠️ If you have already used the container ⚠️:

- Run `docker-compose down --rmi all --remove-orphans` to clear all containers
- Then run `docker-compose up --build`

## 🧠 Recommender System

📄 You can find more details in the file:  
`my recommender system.docx`


---

## 💳 Stripe Test Data

Use this card data for testing payment:

- **Card number:** `4242 4242 4242 4242`
- **Date:** _Any future date_
- **CVC:** _Any 3-digit number_
- **ZIP Code:** _Any 5-digit number_

---

## 📩 RabbitMQ

RabbitMQ is used to **send an email notification** to the client after the driver **accepts or rejects** a drive request.
To fully test RabbitMQ functionality, temporarily update a user's email address to your own, and then follow the steps under Testing Main App Functionality above.
