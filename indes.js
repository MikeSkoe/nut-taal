const fs = require('fs');
const readline = require('readline')

function zipTranslations(left, right, output) {
    const leftOutput = [];
    const rightOutput = [];

    let pendingFilesCount = 2;

    const readLeft = readline.createInterface({
        input: fs.createReadStream(left),
        output: process.stdout,
        console: false
    });
    const readRight = readline.createInterface({
        input: fs.createReadStream(right),
        output: process.stdout,
        console: false
    });

    readLeft.on('line', line => leftOutput.push(line));
    readRight.on('line', line => rightOutput.push(line));

    readLeft.on('close', onClose);
    readRight.on('close', onClose);

    function onClose() {
        if (pendingFilesCount > 1) {
            pendingFilesCount -= 1;
        } else {
            rightOutput.forEach((afr, index) => {
                fs.appendFileSync(
                    output,
                    `${afr}: ${leftOutput[index]}\n`,
                );
            });
        }
    }
}

function removeDublications(path, output) {
    const keys = {};

    const read = readline.createInterface({
        input: fs.createReadStream(path),
        output: process.stdout,
        console: false
    });

    read.on('line', line => {
        const key = line.trim().toLowerCase();

        if (!key.includes(' ') && !keys[key]) {
            keys[key] = true;
            fs.appendFileSync(output, `${key}\n`);
        }
    });
}

zipTranslations("english", "dutch", "translations");
