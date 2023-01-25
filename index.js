const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

(async (j) => {
	const browser = await puppeteer.launch();
	for (let i = 1; i <= j; i++) {
		await (async () => {
			const page = await browser.newPage();
			await page.goto(`file://${path.join(__dirname, "page" + i + ".html")}`);
			await page.evaluate(() => {
				//document.querySelector("div.submitbtns").remove();
				document.querySelectorAll("select").forEach((input) => { input.disabled = false });
				const assets = document.querySelectorAll("link[rel=stylesheet], script");
				const answers = document.querySelector("form.questionflagsaveform");
				document.head.innerHTML = "";
				document.body.innerHTML = "";
				const fontAwesome = document.createElement('link');
				fontAwesome.rel = 'stylesheet';
				fontAwesome.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css';
				document.head.appendChild(fontAwesome);
				const docFrag = document.createDocumentFragment();
				for (let k = 0; k < assets.length; k++) {
					docFrag.appendChild(assets[k]);
				}
				document.body.appendChild(docFrag);
				document.body.appendChild(answers);
			});
			const html = await page.evaluate(() => document.querySelector('*').outerHTML);
			fs.writeFile(__dirname + '/page' + i + '.html', html, err => {
				if (err) {
					console.error(err)
					return
				}
			});
		})();
	}
	await browser.close();
})(process.argv[2]);