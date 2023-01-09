//const readline = require("readline");
import readline from "readline"
import shell from 'shelljs'
import { exec } from 'child_process'

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

var file, engine
rl.question("Enter the name of smart contract: ", function (answer) {
    file = answer;
    rl.question("Enter the engine you would like to use: CHC, BMC: ", function (answer) {
        engine = answer;
        if(engine != "CHC" && engine != "BMC"){
            console.log("\nInvalid engine chosen. Exitting!");
        }
        else{
            console.log("\n\n------------------------------------------------------\n\n")
            console.log("Output:\n")

            if(engine == "BMC"){
                exec('sh asserterBMC.sh ' + file,
                function (error, stdout, stderr) {
                    console.log('stdout: ' + stdout);
                    console.log('stderr: ' + stderr);
                    if (error !== null) {
                    console.log('exec error: ' + error);
                    }
                });
        
                return "Exec done"
            }
            else{
                exec('sh asserterCHC.sh ' + file,
                function (error, stdout, stderr) {
                    console.log('stdout: ' + stdout);
                    console.log('stderr: ' + stderr);
                    if (error !== null) {
                    console.log('exec error: ' + error);
                    }
                });
            }
        }
        rl.close();
    });
});


