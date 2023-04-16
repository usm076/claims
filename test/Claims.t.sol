// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Claims.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ClaimsTest is Test {
    Claims claims;
    IERC20 feeToken;

    function setUp() public {
        feeToken = IERC20(address(this)); // Using the test contract's address as a dummy fee token for testing purposes
        claims = new Claims(address(feeToken), address(this));
    }

    function testTotaylSupply() public {
        uint8 expectedTotalSupply = 0;
        assertEq(claims.totalSupply(), expectedTotalSupply);
    }

    function testTransferFee() public {
        uint256 start = gasleft();
        uint8 expectedTransferFee = 125;

        // Testing the fee update
        claims.updateTransferFee(expectedTransferFee - 10);
        assertEq(claims.getTransferFee(), 115);

        console.log("start: ", start);
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
}
