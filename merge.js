const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');
fs.writeFile(__dirname + 'Full test.html', '', () => { });

(async (j) => {
  const browser = await puppeteer.launch();
  for (let i = 1; i <= j; i++) {
    await (async () => {
      const page = await browser.newPage();
      await page.goto(`file://${path.join(__dirname, "page" + i + ".html")}`);
      let body;
      if (i == 1) {
        body = await page.evaluate(() => document.body.innerHTML);
      } else {	
        body = await page.evaluate(() => document.querySelector("form.questionflagsaveform").innerHTML);
      }
      let content;
      if (i == 1) {
        content = `<!DOCUMENT html><html><head><meta charset="utf8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
        </head><body>` + body;
      } else {
        content = body;
      }
      fs.appendFile(__dirname + 'Full test.html', content, 'utf8', err => {
        if (err) {
          console.error(err)
          return
        }
      });
    })();
  }
  await browser.close();
})(process.argv[2]);