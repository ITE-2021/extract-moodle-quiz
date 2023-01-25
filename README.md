A set of scripts made for extracting quizes from Moodle.

- `browser.ps1` runs Google Chrome with `SSLKEYLOGFILE` enviromental variable and starts network traffic capture using Tshark on current network interface
- `extractor.ps1` runs Tshark and extracts pages with questions and answers
- `index.js` is a Node.js script which removes redundant data from pages
- `merge.js` is a Node.js script which merges pages cleaned by `index.js` into one HTML file