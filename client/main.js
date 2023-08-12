const { Web3Storage, getFilesFromPath, File } = require('web3.storage')
const fs = require('fs');

const jsonFileName = "example.json"

async function main() {
    storageClient = makeStorageClient()
    parsedData = parseJSONFile(jsonFileName)
    if (!parsedData) {
        console.log("error parsing jsonData")
        return
    }

    imagePaths = getImagesFromParsedData(parsedData)
    imagesCID = await uploadFiles(storageClient, imagePaths)
    replaceImagePathsWithCID(parsedData, imagesCID)

    const buffer = Buffer.from(JSON.stringify(parsedData))
    const files = [new File([buffer], jsonFileName)]
    const jsonCID = await storageClient.put(files)
    console.log(`ipfs://${jsonCID}/${jsonFileName}`)
}

function parseJSONFile(filePath) {
    try {
        const jsonString = fs.readFileSync(filePath, 'utf8');
        const jsonData = JSON.parse(jsonString);
        return jsonData;
    } catch (error) {
        console.error('Error parsing JSON:', error.message);
        return null;
    }
}

function getImagesFromParsedData(parsedData) {
    const imagePaths = []

    // Add ingredient images
    for (let i = 0; i < parsedData.Ingredients.length; i++) {
        for (let j = 0; j < parsedData.Ingredients[i].Images.length; j++) {
            imagePaths.push(parsedData.Ingredients[i].Images[j].Path)
        }
    }

    // Add steps images
    for (let i = 0; i < parsedData.Steps.length; i++) {
        for (let j = 0; j < parsedData.Steps[i].Images.length; j++) {
            imagePaths.push(parsedData.Steps[i].Images[j].Path)
        }
    }

    // Add recipe images
    for (let i = 0; i < parsedData.Images.length; i++) {
        imagePaths.push(parsedData.Images[i].Path)
    }

    return imagePaths
}

function replaceImagePathsWithCID(parsedData, cid) {
    for (let i = 0; i < parsedData.Ingredients.length; i++) {
        for (let j = 0; j < parsedData.Ingredients[i].Images.length; j++) {
            pathSplit = parsedData.Ingredients[i].Images[j].Path.split("/")
            fileName = pathSplit[pathSplit.length - 1]
            parsedData.Ingredients[i].Images[j].Link = `ipfs://${cid}/${fileName}`
            delete parsedData.Ingredients[i].Images[j].Path
        }
    }

    for (let i = 0; i < parsedData.Steps.length; i++) {
        for (let j = 0; j < parsedData.Steps[i].Images.length; j++) {
            pathSplit = parsedData.Steps[i].Images[j].Path.split("/")
            fileName = pathSplit[pathSplit.length - 1]
            parsedData.Steps[i].Images[j].Link = `ipfs://${cid}/${fileName}`
            delete parsedData.Steps[i].Images[j].Path
        }
    }

    for (let i = 0; i < parsedData.Images.length; i++) {
        pathSplit = parsedData.Images[i].Path.split("/")
        fileName = pathSplit[pathSplit.length - 1]
        parsedData.Images[i].Link = `ipfs://${cid}/${fileName}`
        delete parsedData.Images[i].Path
    }
}

async function uploadFiles(storageClient, imagePaths) {
    const files = await getFilesFromPath(imagePaths)
    const cid = await storageClient.put(files)
    return cid
}

function makeStorageClient() {
    return new Web3Storage({ token: getAccessToken() })
}

function getAccessToken() {
    return ""
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});