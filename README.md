# Flutter Application

A Flutter application structured using a clean architecture approach
with separate layers for views, view models, repositories, services, and
data models.

## Project Structure

lib/
├── core/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── router/
├── shared/
├── view/   
│   ├── auth/
│   ├── dashboard/
│   ├── home/
│   ├── insights/
│   └── orders/
├── viewmodels/
└── main.dart

## Features

-   User authentication
-   Dashboard screen
-   Home screen
-   Insights module
-   Order creation and management
-   Repository and service layers
-   State management with ViewModels
-   Razorpay payment integration

## Technologies

-   Flutter
-   Dart
-   MVVM architecture
-   Repository pattern

## Getting Started

### Install dependencies

``` bash
flutter pub get
```

### Run the application

``` bash
flutter run
```

## Build

``` bash
flutter build apk
```
