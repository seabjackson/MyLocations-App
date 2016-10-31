# MyLocations-App
An app that uses Core Location Framework to obtain GPS coordinates of a user's whereabouts...

This app can be navigated via a tab bar controller. The first view is where the user can press the 
"Get My Location" button to get their current coordinates in latitude and logitude. The user can then Add 
information about that location by pressing "Add Location Details". This will take them to the LocationDetailsViewController
, which is to say a view where the user can add information about their current location, such as a description, a category, and
even a picture in their photo album library, or better yet take a photo of the place.

The second tab, Locations, is a table arranged by categories, and presents a list of all the locations that the user has added. Each location has a photo, the name of the location, and the actual address. Selecting a location in the table will allow you to edit information for that particular location. The user can hit the Edit button to delete a location.

The third tag, Map can show to configurations of the map. The left bar button item at the top of the navigation bar, is an icon that signifies all the locations on the map. It tries to provide a wholistic view if possible of all the locations ever tagged, so you can see them easily. The right bar button item at the top of the navigation bar's icon allows you to view on the map the user's current location.
Pins on the map are displayed in green, and when tapped will display a disclosure button with information about the name of the location,
and the category it belongs to. Tapping this disclosure button will also take you to the Edit Location screen where you can look up information about the location, such as latitude, longitude, and address, or change the photo, category, or description for said location.

The final tab, photos, basically automatically gets the user's location and display photos that were taken at that specific location.
Soon the app will embrace a social aspect to it where a user will be able to look up the locations, and photos of other users on the map, so they can have a sense of sharing remarkable pictures of places around the globe. Every one will be there own Cristopher Columbus and share their findings with the masses, so that others can enjoy those discoveries.
