iOS6MapSatelliteZoomIssue
=========================

Demo app that illustrates issue with iOS map and zooming to full limits of map. Contains working solution for protections to avoid issue.

In iOS6, MKMapKit has an issue with displaying satellite images at the highest zoom level. This can easily be seen in any map that uses MKMapView. To see the bug, try the following:
* Open an MKMapView
* Switch to a map type that shows Satellite images.
* Zoom all the way out

You will see the map switch to the gridded "no satellite imagery" view. 
![ScreenShot](https://raw.github.com/DeepFriedTwinkie/iOS6MapZoomIssue/master/Grid_Screenshot.png)

This sample app shows the issue at work. Simply tap one of the four buttons in the lower left corner of the view. They are:
* Small - Zooms into a location at the highest zoom level (a 1m square) with MKMapTypeStandard - No issue shown
* Large - Zooms into a location at a moderate zoom level (a 3km square) with MKMapTypeStandard - No Issue shown
* S Hyb - Same as "Small" but with Satellite Imagery (MKMapTypeHybrid) - Issue is displayed
* L Hyb - Same as "Large" but with Satellite Imagery (MKMapTypeHybrid) - No issue shown

Solution
The sample app attempts to protect against the issue by not allowing the user to call setRegion: on a zoom level greater than or equal to 20. The CustomMapView : MKMapView class overrides setRegion: to add in this protection. You can see it work by toggling the "Protect" switch.
