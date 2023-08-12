// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {SchemaResolver} from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import {IEAS, Attestation} from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

contract TasteProtocol is SchemaResolver {
    using SafeERC20 for IERC20;
    struct RecipeData {
        string _recipeName;
        uint256 requestID;
        uint256 arrayIndex;
    }
    struct Recipe {
        string ipfsFolderURL;
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
    mapping(uint256 => mapping(address => address)) public voteMap;
    mapping(uint256 => RecipeRequest) public requests;

    uint256 public idCounter;
    address public tokenAddr;

    constructor(IEAS eas, address _tokenAddr) SchemaResolver(eas) {
        tokenAddr = _tokenAddr;
    }

    function requestRecipe(
        string calldata _recipeName,
        uint256 _requestEndDate,
        uint256 _reward
    ) external {
        IERC20(tokenAddr).safeTransferFrom(msg.sender, address(this), _reward);
        requests[idCounter].recipeName = _recipeName;
        requests[idCounter].requestEndDate = _requestEndDate;
        requests[idCounter].reward = _reward;
        requests[idCounter].requester = msg.sender;
        idCounter++;
    }

    function fulfilRequest(
        uint256 _id,
        string calldata _recipeName,
        string calldata _IPFSFolderURL
    ) external {
        RecipeRequest storage r = requests[_id];
        require(
            keccak256(abi.encode(r.recipeName)) ==
                keccak256(abi.encode(_recipeName)),
            "recipe names do not match"
        );

        Recipe memory newRecipe;
        newRecipe.author = msg.sender;
        newRecipe.ipfsFolderURL = _IPFSFolderURL;

        r.recipeSubmissions.push(newRecipe);
        
        for (uint256 i = 0; i < authorRecipeIndex[msg.sender].length; i++) {
            require(_id != authorRecipeIndex[msg.sender][i].requestID, "only one submission per request");
        }
        RecipeData memory newData;
        newData._recipeName = _recipeName;
        newData.arrayIndex = r.recipeSubmissions.length - 1;
        newData.requestID = _id;
        authorRecipeIndex[msg.sender].push(newData);
    }

    // EAS, hook attestation schema into this
    function voteRecipe(
        uint256 _id,
        string memory _recipeName,
        address _recipeAuthor
    ) internal {
        RecipeRequest storage r = requests[_id];
        require(
            keccak256(abi.encode(r.recipeName)) ==
                keccak256(abi.encode(_recipeName)),
            "recipe names do not match"
        );
        for (uint256 i = 0; i < r.recipeSubmissions.length; i++) {
            if (r.recipeSubmissions[i].author == _recipeAuthor) {
                r.recipeSubmissions[i].voteCount += 1;
                return;
            }
        }
        require(false, "Author not found");
    }

    // payout votes
    function decideWinner(uint256 _id, string calldata _recipeName) external {
        RecipeRequest storage r = requests[_id];
        require(
            keccak256(abi.encode(r.recipeName)) ==
                keccak256(abi.encode(_recipeName)),
            "recipe names do not match"
        );
        require(
            block.timestamp >= r.requestEndDate,
            "Voting period isn't finished"
        );
        uint256 votesToBeat = 0;
        uint256 winnerIndex = 0;
        for (uint256 i = 0; i < r.recipeSubmissions.length; i++) {
            if (r.recipeSubmissions[i].voteCount > votesToBeat) {
                winnerIndex = i;
            }
        }
        r.winner = r.recipeSubmissions[winnerIndex];
        requests[_id] = r;

        IERC20(tokenAddr).safeTransfer(r.winner.author, r.reward);
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 value
    ) internal override returns (bool) {
        
        (address author, string memory recipeName) = abi.decode(attestation.data, (address, string));
        require(voteMap[value][attestation.attester] == address(0), "attester already voted on this request");
        voteMap[value][attestation.attester] = author;
        voteRecipe(value, recipeName, author);
        return true;
    }

    function onRevoke(
        Attestation calldata /*attestation*/,
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return true;
    }
}
