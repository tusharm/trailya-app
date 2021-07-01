# trailya

A privacy-focussed mobile app that tracks your location and notifies if you've been to a COVID exposure site.

The app pulls exposure sites from a Google Firestore collection (populated daily by a separate job) and shows them in a list.
It tracks locations you visited for more than a minute (even in background mode) and stores it locally (imp: doesn't share with any remote service).
It will notify you if you past visits co-incide with an exposure site (coming soon!). 

### Screenshots

| Sign In | Exposure Site List | Site | 
| ------- | ------------------- |  -- | 
| <img src="doc/images/signin.png" alt="Sign In" width="200"/> |  <img src="doc/images/sites-list.png" alt="Exposure Site List" width="200"/> | <img src="doc/images/site.png" alt="Site" width="200"/> |


| Site Details | Sites on map | My visits |
| -- | -- | -- |
|  <img src="doc/images/site-details.png" alt="Site Details" width="200"/> | <img src="doc/images/sites-on-map.png" alt="Sites on map" width="200"/> | <img src="doc/images/my-visit.png" alt="My visit" width="200"/> |
