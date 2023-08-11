// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TasteProtocol  {

    using SafeERC20 for IERC20;
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

    mapping(address => RecipeData[]) public authorRecipeIndex;
    mapping(uint256 => RecipeRequest) public requests;

    uint256 public idCounter;
    address public tokenAddr;

    constructor(address _tokenAddr) {
        tokenAddr = _tokenAddr;
    }

    function requestRecipe(string calldata _recipeName, uint256 _requestEndDate, uint256 _reward) external {

        IERC20(tokenAddr).safeTransferFrom(msg.sender, address(this), _reward);
        RecipeRequest memory newRequest;
        newRequest.recipeName = _recipeName;
        newRequest.requestEndDate = _requestEndDate;
        newRequest.reward = _reward;
        newRequest.requester = msg.sender;
        requests[idCounter] = newRequest;
        idCounter++;

    }

    function fulfilRequest(uint256 _id, string calldata _recipeName, string calldata _IPFSFolderURL) external {
        
        RecipeRequest storage r = requests[_id];
        require(keccak256(abi.encode(r.recipeName)) == keccak256(abi.encode(_recipeName)), "recipe names do not match");

        Recipe memory newRecipe;
        newRecipe.author = msg.sender;
        newRecipe.ipfsFolderURL = _IPFSFolderURL;

        r.recipeSubmissions.push(newRecipe);

        RecipeData memory newData;
        newData._recipeName = _recipeName;
        newData.arrayIndex = r.recipeSubmissions.length - 1;
        newData.requestID = _id;
        authorRecipeIndex[msg.sender].push(newData);
    }

    // EAS, hook attestation schema into this
    function voteRecipe(string calldata _recipeName, address _recipeAuthor) external {

    }

    // payout votes
    function decideWinner() external {

    }
}