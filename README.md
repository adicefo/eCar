# eCar

**A project for purposes of the "Razvoj Softvera II" subject.**

## Credentials

### Admin (desktop app):

- **Email:** `admin@edu.fit.ba`
- **Password:** `test`

### Client (mobile app):

- **Email:** `client1@edu.fit.ba`
- **Password:** `test`
- **Note:** `Same credentials for client2 and client3`

### Driver (mobile app):

- **Email:** `driver1@edu.fit.ba`
- **Password:** `test`
- **Note:** `Same credentials for driver2 and driver3`

## IMPORTANT! Emulator setup for Google Navigation SDK

**In this app Google Navigation SDK is used and in order to run app properly there are some requirments for emulator:**

- **Use image with API 35**
- **Enable Google Play Services**
- **Enable Wi-Fi**
- **Enable Location**

## Steps for testing main app functionality

**These are steps to test main app drive funcionality:**

- **Login as a driver with mentioned credentials**
- **Car icon in appbar->Assign car**
- **Login as a client->Order->Choose car->Send drive request**
- **Login as a driver->Requests->Accept Request**
- **After accepting go to Drives and then click Start drive**

**NOTE: If you test mobile app on emulator use location in American continent because default location of emulator is somewhere near San Francisco!!!**

## Docker

**In order to run app go to path of docker-compose.yaml and run `docker-compose up --build `**

**NOTE: Do not run migration because database is already created with test data inserted!!!**

## Recommender system

**You can find the more information about recommender in `my recommender system.docx ` file**

**NOTE:If you get message `Sorry, there is no recommended vehicles based on previous car.` for all vehicles while testing the app, please add few rent requests for different users while testing.**

## Stripe data

- **Card number:** `4242 4242 4242 4242`
- **Date:** `Any date in future`
- **CVC:** `Any 3-digit number`
- **ZIP Code:** `Any 5-digit number`

## RabbitMQ

- **Rabbitmq is used to send an email to client after driver accept or reject his drive request.**
