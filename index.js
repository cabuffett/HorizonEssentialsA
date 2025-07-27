const express = require('express');
const app = express();
app.use(express.json()); // Middleware to parse JSON bodies

// IMPORTANT: Make sure this key matches the one on your web page and in your Adonis plugin
const secretApiKey = 'REPLACE_THIS_WITH_YOUR_SECRET_KEY';

// This variable will store the latest command from the web panel
let pendingCommand = null;

// Endpoint for the web page to send a command to
app.post('/set-event', (req, res) => {
    const { apiKey, command } = req.body;

    if (apiKey !== secretApiKey) {
        return res.status(403).json({ message: 'Invalid API Key' });
    }

    if (!command) {
        return res.status(400).json({ message: 'Command not provided' });
    }
  
    console.log(`Received command: ${command}`);
    pendingCommand = command; // Store the command

    res.status(200).json({ message: 'Command received and waiting for game server.' });
});

// Endpoint for the Roblox game to poll for commands
app.get('/get-event', (req, res) => {
    if (pendingCommand) {
        console.log(`Sending command "${pendingCommand}" to game server.`);
        res.json({ command: pendingCommand });
        pendingCommand = null; // Clear the command after it's been sent
    } else {
        res.json({ command: null }); // No command waiting
    }
});

// Listen for requests
const listener = app.listen(process.env.PORT, () => {
    console.log('Your app is listening on port ' + listener.address().port);
});
