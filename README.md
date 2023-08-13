# Superhack-Taste-Protocol

Taste Protocol is ...
### Getting Started

    npm install

create a secrets.json file in the root of the repo
Example:
    
    {
        "privateKey" : "your wallet key for deployment",
        "web3StorageAccessToken" : "your web3.storage api key for IPFS upload"
    }

To run the IPFS uploader client

    cd ./client
    node ./main.js
### Deployed Addresses

    OpGoerliTestToken: "0x38e11739B8A33A906b70b67F16E9455ea1f4d08b"
    OpGoerliTasteProtocol : "0x9CA5455DC4026bD68EC7b19669bf4c5D85Ef9EEF"
    ModeSepoliaTestToken: "0x38e11739B8A33A906b70b67F16E9455ea1f4d08b"
    ModeSepoliaTasteProtocol : "0x9CA5455DC4026bD68EC7b19669bf4c5D85Ef9EEF"
    BaseGoerliTestToken : "0x9CA5455DC4026bD68EC7b19669bf4c5D85Ef9EEF"
    BaseGoerliTasteProtocol: "0x220026179048d5a92DF04200a99A2D71753adb58"
    ZoraGoerliTestToken : "0x9CA5455DC4026bD68EC7b19669bf4c5D85Ef9EEF"
    ZoraGoerliTasteProtocol: "0x220026179048d5a92DF04200a99A2D71753adb58"

### EAS Support
Optimism Goerli & Base Goerli have EAS support, voting on these chains will be done using Attestations

Optimism Goerli:
    
    https://optimism-goerli-bedrock.easscan.org/schema/view/0x0d4cdccf1de7faecc00290499f31031594884063288be7e9dee934a9d3f10248

Base Goerli:
    
    https://base-goerli.easscan.org/schema/view/0x97b0cc0e548a86f95b64e5c1997f64e08b28d73a43f164a7136baf7ff512f3f7

### Regular Voting
Mode Sepolia & Zora Goerli:
Please use the follow function on Taste Protocol Smart Contract
    
    function voteRecipe(uint256 _id, string memory _recipeName, address _recipeAuthor) external;
