// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "forge-std/Test.sol";
import "../src/Claims.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ClaimsTest is DSTest {
    Claims claims;
    IERC20 feeToken;

    function setUp() public {
        feeToken = IERC20(address(this)); // Using the test contract's address as a dummy fee token for testing purposes
        claims = new Claims(address(feeToken), address(this));
    }

    function testName() public {
        assertEq(claims.name(), "Claims");
    }

    function testSymbol() public {
        assertEq(claims.symbol(), "CLAIMS_USD_NFT");
    }

    function testTotaylSupply() public {
        uint8 expectedTotalSupply = 0;
        assertEq(claims.totalSupply(), expectedTotalSupply);
    }

    function testGetTransferFee() public {
        uint8 expectedTransferFee = 125;
        assertEq(claims.getTransferFee(), expectedTransferFee);
    }
}
