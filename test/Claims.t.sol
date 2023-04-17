// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Claims.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ClaimsTest is Test {
    Claims claims;
    IERC20 feeToken;
    address originalOwner = address(0x123);
    address referrer = address(0x456);
    uint256 faceValue = 1 ether;
    string encryptedSymmetricKey = "encryptedSymmetricKey";
    string ipfsUri = "dummyIpfsUri";

    function setUp() public {
        feeToken = IERC20(address(this)); // Using the test contract's address as a dummy fee token for testing purposes
        claims = new Claims(address(feeToken), address(this));
    }

    function testTotaylSupply() public {
        uint8 expectedTotalSupply = 0;
        assertEq(claims.totalSupply(), expectedTotalSupply);
    }

    function testTransferFee() public {
        uint8 expectedTransferFee = 125;
        // Testing the fee update
        claims.updateTransferFee(expectedTransferFee - 10);
        assertEq(claims.getTransferFee(), 115);
    }

    function test_RevertIf_NotOwner() public {
        // Change signer address to a non-owner
        address nonOwner = address(0x123); // Replace with a valid non-owner address
        vm.startPrank(nonOwner);
        vm.expectRevert("Ownable: caller is not the owner");
        // Attempting to update the fee with a non-owner should revert
        claims.updateTransferFee(115);
        assertEq(claims.getTransferFee(), 125);
    }

    function testMintNft() public {
        
        claims.mintNft(originalOwner, referrer, faceValue, encryptedSymmetricKey, ipfsUri);
        assertEq(claims.totalSupply(), 1);
        assertEq(claims.tokenURI(1), "dummyIpfsUri");
    }
    function test_RevertIf_NotOwnerMintNft() public {
        
        // Change signer address to a non-owner
        address nonOwner = address(0x123); // Replace with a valid non-owner address
        vm.startPrank(nonOwner);
        // Attempting to update the fee with a non-owner should revert
        vm.expectRevert("Ownable: caller is not the owner");
        claims.mintNft(originalOwner, referrer, faceValue, encryptedSymmetricKey, ipfsUri);

        assertEq(claims.totalSupply(), 0);
        vm.expectRevert("ERC721: invalid token ID");
        claims.tokenURI(1);
    }

    function testUpdateTokenURI() public {

        claims.mintNft(originalOwner, referrer, faceValue, encryptedSymmetricKey, ipfsUri);
        // Change signer address to a non-owner
        address nonOwner = address(0x123); // Replace with a valid non-owner address
        vm.startPrank(nonOwner);
        // Attempting to update the fee with a non-owner should revert
        vm.expectRevert("Ownable: caller is not the owner");
        claims.updateTokenURI(1, "updated token URI");

        vm.stopPrank();
        claims.updateTokenURI(1, "updated token URI");
        assertEq(claims.tokenURI(1), "updated token URI");
    }

    function testCustomTrasferFrom() public view {
        console.log("Need more info to write a test for POC I have provided with a general idea how the attack might happen.");
        // Need more info to write a test for POC I have provided with a general idea how the attack might happen.
    }
}
