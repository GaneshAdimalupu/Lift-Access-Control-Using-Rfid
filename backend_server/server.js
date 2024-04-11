const express = require('express');
const app = express();
const port = 3000; // Choose a port for your server

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Server is listening at http://localhost:${port}`);
});
const admin = require('firebase-admin');
const serviceAccount = require('C:/Users/Alphin Paul Dcruz/Downloads/lift-access-control-firebase-adminsdk-1i94z-f1dec8acb1.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
