// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Claims is ERC721URIStorage, ERC721Burnable, ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    IERC20 private _feeToken;
    uint8 private _transferFee; // Transfer fee percentage as a fixed-point number (e.g., 1.25% = 125)
    address private _feeRecipient;

    struct nft {
        address originalOwner;
        address referrer;
        uint256 faceValue;
        string encryptedSymmetricKey;
    }

    mapping(uint256 => nft) private tokenIdToNft;
    mapping(uint256 => mapping(address => bool)) private _approvedFeePayers;

    constructor(
        address feeTokenAddress,
        address feeRecipient
    ) ERC721("Claims", "CLAIMS_USD_NFT") {
        _feeToken = IERC20(feeTokenAddress);
        _transferFee = 125;
        _feeRecipient = feeRecipient;
    }

    function mintNft(
        address originalOwner,
        address referrer,
        uint256 faceValue,
        string memory encryptedSymmetricKey,
        string memory ipfsUri
    ) public onlyOwner {
        _tokenIds.increment();
        uint256 newNftTokenId = _tokenIds.current();
        _safeMint(originalOwner, newNftTokenId);
        _setTokenURI(newNftTokenId, ipfsUri);
        tokenIdToNft[newNftTokenId] = nft(
            originalOwner,
            referrer,
            faceValue,
            encryptedSymmetricKey
        );
    }

    function updateTokenURI(uint256 tokenId, string memory newIpfsUri) public onlyOwner {
    require(_exists(tokenId), "ERC721: Token ID does not exist");
    _setTokenURI(tokenId, newIpfsUri);
}

// Overrides transferFrom() to add a transfer fee
    function transferFrom(
        address from,
        address to,
        uint256 tokenId,
        address feePayer
    ) public virtual {
        require(_approvedFeePayers[tokenId][feePayer], "ERC721: Fee payer has not approved this token ID");

        uint256 faceValue = tokenIdToNft[tokenId].faceValue;
        uint256 fee = (faceValue * _transferFee) / 10000; // Assuming the transfer fee is in basis points (1% = 100)
        fee = fee * 10**18; // Assuming the ERC20 token has 18 decimal places
        uint256 referrerCommission = (fee * 20) / 100; // Calculate 20% of the fee as the commission for the referrer
        uint256 remainingFee = fee - referrerCommission; // Calculate the remaining fee for the feeRecipient
        
        // ERC20 approval must be granted to the deployed ERC721 contract address
        // Transfer the commission to the referrer
        address referrer = tokenIdToNft[tokenId].referrer;
        require(
            _feeToken.transferFrom(feePayer, referrer, referrerCommission),
            "ERC721: Must have approval for referrer commission transfer"
        );

        // Transfer the remaining fee to the fee recipient
        require(
            _feeToken.transferFrom(feePayer, _feeRecipient, remainingFee),
            "ERC721: Must have approval for fee transfer"
        );

        // Call the original transferFrom() function from the ERC721 contract
        super.transferFrom(from, to, tokenId);
    }

    function approveFeeForId(uint256 tokenId) public {
        require(_exists(tokenId), "ERC721: Token ID does not exist");
        _approvedFeePayers[tokenId][_msgSender()] = true;
    }

    function revokeFeeForId(uint256 tokenId) public {
        require(_exists(tokenId), "ERC721: Token ID does not exist");
        _approvedFeePayers[tokenId][_msgSender()] = false;
    }

    function updateFeeTokenAddress(address newFeeTokenAddress) public onlyOwner {
        _feeToken = IERC20(newFeeTokenAddress);
    }

    function updateFeeRecipient(address newFeeRecipient) public onlyOwner {
        _feeRecipient = newFeeRecipient;
    }

    function updateTransferFee(uint8 newTransferFee) public onlyOwner {
        require(newTransferFee <= 125, "ERC721: Transfer fee cannot be more than 1.25%");
        _transferFee = newTransferFee;
    }

    function getTransferFee() public view returns (uint8) {
        return _transferFee;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

}