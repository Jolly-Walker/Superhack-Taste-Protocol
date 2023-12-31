# Superhack-Taste-Protocol

Taste Protocol facilites collaborative compilation of heritage recipies, powered by smart contracts and IPFS. Our main functionality is to allow users to view, publish, request and vote on recipes submissions. With the key goal of preserving traditional and heritage recipies beloved by people worldwide.
### Getting Started

    npm install

Create a secrets.json file in the root of the repo
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

### EAS Attestation Voting
Optimism Goerli & Base Goerli have EAS, voting on these chains will be done using Attestations

Optimism Goerli:
    
    https://optimism-goerli-bedrock.easscan.org/schema/view/0x0d4cdccf1de7faecc00290499f31031594884063288be7e9dee934a9d3f10248

Base Goerli:
    
    https://base-goerli.easscan.org/schema/view/0x97b0cc0e548a86f95b64e5c1997f64e08b28d73a43f164a7136baf7ff512f3f7

### Regular Voting
Mode Sepolia & Zora Goerli:
Please use the follow function on Taste Protocol Smart Contract
    
    function voteRecipe(uint256 _id, string memory _recipeName, address _recipeAuthor) external;

### Request Recipes
Request a recipe on Taste Protocol, providing a reward bounty to incentives recipe submissions

    function requestRecipe(string calldata _recipeName, uint256 _requestEndDate, uint256 _reward) external

### Upload Recipes
Submit a recipe entry to any request on Taste Protocol, using the following function

    function fulfilRequest(uint256 _id, string calldata _recipeName, string calldata _IPFSFolderURL) external

### Decide Winning Recipe
The Requester calls this function to end the voting process and distribute the reward tokens to the most popular recipe
The Requester also picks their favourite recipe by specifying the recipe author, which will also get a reward

    function decideWinner(uint256 _id, string calldata _recipeName, address _favorite) external

### Get Test Reward Tokens
Simply request for the tokens using this function from a testToken contract address

    function getToken(uint256 _amount) external
