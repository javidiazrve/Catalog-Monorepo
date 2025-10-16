# Catalog System (Flutter And Angular)

Monorepo with a Flutter App (Creator) and an Angular Web App (Admin).

## Setup

### Flutter App

1# - cd flutter_app

2# - install dependencies -> flutter pub get

### Angular App

1# - cd angular_app

2# - install modules -> npm install

## Run

### Start Server in Flutter

From root:

1# - dart run flutter_app/lib/Server/api_server.dart

or in flutter_app folder:

1# - cd flutter_app
2# - dart run lib/Server/api_server.dart

should show this message in the terminal:

✅ API Server running at http://<some-IP>:8080

### Start Flutter App

1# - cd flutter_app
2# - flutter run
3# - select in the terminal the platform of your preference

### Start Angular Admin

1# - cd angular_app
2# - ng serve

it should open a browser window with the app in "http://localhost:4200/admin" url.

## User Manual

### Flutter App

- Once the app is running you will see a list of items already created, this is for fast testing.

- Tap on the floating button at the rigth-bottom corner, this will open de creation view, there you can create a new item, fill the fields and press the "create item" button.

- Then you would see a snackbar telling you if the action was succeded or not. The fields will restart so you can create as much items as you like.

- To go back use de back arrow in the appbar.

- The list would be already updated with the new items, but if you need it you can refresh with new data from the server scrolling down the list until a refresh icon appears on screen. It will do another call to the server and refresh the data, use it to see the changes done in the admin panel.

### Angular App

- First you see the list of items and the different types of filters. Write in the search bar to search an item by the title, select a category to filter by category, select Ascending or Descending in the Quality Score Select Field to sort the items in the order of your preference, and click the refresh botton to refresh de data.

- To view the items data click on them, it will open a card where you can see all the details and approve the item if it fulfills the requirements, if not, then you could see a message letting you know if the item has been already approved or if it's quality score is so low.

- Once you click de approve button it will update de card and the list.
