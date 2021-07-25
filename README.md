# trailya

<img src="doc/images/trailya-icon.png" alt="trailya" width="100"/>

Mobile app to track COVID exposure sites in Australia and notify user if they are potentially exposed.

[Privacy Policy](./PRIVACY.md)

_Twitter_: [@aus_trailya](https://twitter.com/aus_trailya)

_Status_: Beta testing. Please reply on the twitter handle if you want to be an early tester.

### Why is it needed?

- State Health's COVID exposure site updates aren't easy to consume (eg. huge tables on webpages, multiple tweets, PDF files etc.)
- How do I know if I was exposed (with reasonable confidence)?

### How does this help?

A privacy-focussed mobile app that:

- syncs current exposure sites and shows them on a map and as a list
- tracks users locations where they have spent more than a minute
  - visits are shown on the map, to help visualize if there is a possible exposure
  - visits are stored only on the device (not shared outside); they are removed if older than 15 days
  - notify if user has been to an exposure site (coming soon)

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
