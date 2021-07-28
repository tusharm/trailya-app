# trailya

<img src="doc/images/trailya-icon.png" alt="trailya" width="100"/>

Open-source non-commercial app to track Australian COVID exposure sites and identify the user's possible exposures. 

Uses publicly available datasets:
- [NSW COVID-19 case locations](https://data.nsw.gov.au/search/dataset/ds-nsw-ckan-0a52e6c1-bc0b-48af-8b45-d791a6d8e289/details)
- [All Victorian SARS-CoV-2 (COVID-19) current exposure sites](https://discover.data.vic.gov.au/dataset/all-victorian-sars-cov-2-covid-19-current-exposure-sites/resource/afb52611-6061-4a2b-9110-74c920bede77)

[Privacy Policy](./PRIVACY.md)

_Twitter_: [@aus_trailya](https://twitter.com/aus_trailya)

_Status_: Beta testing. Please reply on the twitter handle if you want to be an early tester.

### Why is it needed?

- Health department's COVID exposure site list isn't easy to consume (eg. huge tables on webpages, multiple tweets, PDF files etc.)
- Getting site update notifications reduces the effort to search
- Reduce effort/error in identifying if the user was at one of the exposure sites

### How does this help?

A privacy-focussed mobile app that:

- lists exposure sites, shows them on a map, allows filtering based on dates, suburbs etc.
- notifies about exposure site updates
- records locations where user spent more than a specific duration (currently 1 min)
  - uses these "visits" to match against exposure sites
  - notifies if user could be potentially exposed (coming soon)

#### Notes

- Supported on Android; iOS support in future.
- Supports NSW and VIC currently; other states will be supported soon

### Screenshots

| Demo                                                                          |
| ----------------------------------------------------------------------------- |
| <img src="doc/images/trailya_demo.gif" alt="Exposure Site List" width="200"/> |

### Design

| System Design                                               | Flutter Design                                              |
| ----------------------------------------------------------- | ----------------------------------------------------------- |
| <img src="doc/images/system.png" alt="Design" width="300"/> | <img src="doc/images/design.png" alt="Design" width="300"/> |
