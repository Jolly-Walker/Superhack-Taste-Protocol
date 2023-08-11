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
        uint256 requestEndDate;
        Recipe winner;
        uint256 reward;
        address requester;
        Recipe[] recipeSubmissions;
    }

    mapping(address => RecipeData[]) public recipeIndex;
    mapping(string => RecipeRequest) public requests;

    function requestRecipe(string calldata _recipeName, uint256 _requestEndDate, uint256 _reward) external {

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