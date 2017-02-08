Hi, and welcome to your OpenTable assignment.

The goal of this exercise is to test a bit your UIKit skills. Your task is do "our" job, and build our app's upcoming reservation view, also known as "dining mode" internally.
There are 2 aspects to this:

- first, the "dining mode banner". That's an apple music-like banner, that inserts itself above the tab bar, and can be interactively pulled
- second, the dining mode itself. This is a "card" oriented view of your upcoming reservation.

### Dining mode banner
The requirement for this one is pretty simple. Implementing a little bit less so :)

- a banner should be displayed above the tab bar
- tapping the banner expands the upcoming reservation view controller full screen
- the banner can also be dragged interactively, and the upcoming reservation is visible while the banner is dragged (e.g. exactly what Apple Music does)
- whichever tab is selected, the banner should be visible. If a controller gets presented modally, the banner should NOT be visible (matching the implicit real life analogy that modals slide "over" the main view)

Here's a sample GIF from our current app: http://opentable.d.pr/aZ8Q/tdvdDsZ2

### Dining mode
This is a typical "mix and match" content driven screen, laying out "cards" vertically, where some of the content might not be available:

- First card lists the restaurant name, the reservation time, the party size, and includes a picture of the restaurant
- Second card lists the restaurant address, along with a map of the restaurant's address
- Third card is the "best dishes" feature: an optional list of 1 to 3 dishes, along with a review snippet, where mentions of the dish are emphasized. Some ground rules about dishes:
	* A dish has at least one photo, and exactly one snippet
	* A snippet holds the full review, a range which indicates which part should be displayed, and a list of highlight ranges. All the ranges are relative to the full review (e.g. a highlight  at (197, 8) means "8 characters starting from the 197th character in the full review", regardless of which range of the review should be displayed).
	* if the restaurant has no dishes, the card should not be shown
	* if the restaurant has more than 3 dishes, only the first 3 should be shown
	* each dish is guaranteed to have at least one picture, and one review snippet
	* for each displayed snippet, we want to display: the photo, the dish name and the snippet along with its highlight. You're free to pick whatever method for the highlight (bold, color, underline etc.)
- If you feel like it and have enough time (we all have a lot of free time, don't we? :), tapping anywhere in the card expands the card full screen. I'd also be perfectly happy with a simple explanation of how you'd implement this at a high level.

Here's a sample GIF from our current app: http://opentable.d.pr/tgCj/5ohCOmky

### General Instructions:
- this isn't a visual design exercise, so you don't have to worry about that piece. Typically, if you want to set background colors to clearly differentiate the views when debugging, you can send your PR with those colors in.
- I've included GIFs from our own app, for inspiration, but you don't have to follow that visual design
- You'll find some code under Vendor/ – I've put basic domain objects in there, a reference JSON file, and assembler code to build up the domain object from the JSON object.
- I do realize there's a *lot* in this exercise. If you can't wrap it all up (and you probably won't), prioritize things and let me know why you picked something over something else.
- I've included a binary distro of AFNetworking for the image download part, feel free to use it. Or you can stick with raw NSURLSessions if you're more comfortable with that.
