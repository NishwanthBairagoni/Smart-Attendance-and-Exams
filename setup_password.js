const fs = require('fs');
const readline = require('readline');
const path = require('path');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

console.log("\n=================================================");
console.log("   Smart Campus Dashboard Setup");
console.log("=================================================");
console.log("To connect to your database, we need your MySQL root password.");
console.log("(Note: This will be saved locally in server.js)\n");

rl.question('Enter your MySQL Password: ', (password) => {
    if (!password) {
        console.log("Password cannot be empty.");
        rl.close();
        return;
    }

    const serverFile = path.join(__dirname, 'server.js');

    fs.readFile(serverFile, 'utf8', (err, data) => {
        if (err) {
            console.error("Error reading server.js:", err);
            rl.close();
            return;
        }

        // Replace the default password with the user provided one
        const updatedData = data.replace("password: 'password', // <--- UPDATE THIS", `password: '${password}',`);

        fs.writeFile(serverFile, updatedData, 'utf8', (err) => {
            if (err) {
                console.error("Error writing to server.js:", err);
            } else {
                console.log("\n✅ Password saved successfully!");
                console.log("You can now run 'node server.js' to start the app.");
            }
            rl.close();
        });
    });
});
