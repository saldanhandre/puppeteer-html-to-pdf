const express = require("express");
const puppeteer = require("puppeteer");

const app = express();
app.use(express.text({ type: "*/*", limit: "10mb" }));

app.post("/", async (req, res) => {
  const html = req.body;
  try {
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
    });
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: "networkidle0" });

    const pdf = await page.pdf({ format: "A4" });

    await browser.close();
    res.set({
      "Content-Type": "application/pdf",
      "Content-Length": pdf.length,
    });
    res.send(pdf);
  } catch (err) {
    console.error(err);
    res.status(500).send("PDF generation failed");
  }
});

app.listen(3000, () => {
  console.log("PDF server running on port 3000");
});
