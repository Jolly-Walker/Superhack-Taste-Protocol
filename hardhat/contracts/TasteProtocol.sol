// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TasteProtocol  {

    struct RecipeData {
        string  _recipeName;
        uint256 requestID;
        uint256 arrayIndex;
    }
    struct Recipe {
        string  ipfsFolderURL;
        address author;
        uint256 voteCount;
    }
    struct RecipeRequest {
        string recipeName;
        uint256 requestEndDate;
        uint256 reward;
        address requester;
        Recipe[] recipeSubmissions;
        Recipe winner;
    }

    mapping(address => RecipeData[]) public recipeIndex;
    mapping(uint256 => RecipeRequest) public requests;

    uint256 public idCounter;

    constructor() {
    }

    function requestRecipe(string calldata _recipeName, uint256 _requestEndDate, uint256 _reward) external {
        RecipeRequest memory newRequest;
        newRequest.recipeName = _recipeName;
        newRequest.requestEndDate = _requestEndDate;
        newRequest.reward = _reward;
        newRequest.requester = msg.sender;
        requests[idCounter] = newRequest;
        idCounter++;

    }

    function fulfilRequest(string calldata _recipeName, string calldata _IPFSFolderURL) external {

    }

    // EAS, hook attestation schema into this
    function voteRecipe(string calldata _recipeName, address _recipeAuthor) external {

    }

    // payout votes
    function decideWinner() external {

    }
}