# Trademe-Technical-Test-App
Repo for the Trademe Technical Test App by Ryan Campion for the role of Senior iOS Developer at Trademe

## Notes
* I found the Sandbox API mostly returns Property Listings for the latest listings. You can swap between mock data and live data by changing the App Schemes. It might be worth also running the mock data scheme to verify the UI better.
* The Sandbox API also sometimes returns listings with no photos in the photoURLs list. If they don't I use the pictureHref property instead. If both those are nil I use a default Trademe logo image.
* It wasn't in the Acceptance Criteria but I added the ReserveState from the API Listing Response as it was in the designs.

## Nice Extras
* Dark Mode Friendly
* Live/Mock Data switching via Scheme selection
* Error handling to UI Alert for Fetching Live Data

