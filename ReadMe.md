# Disclaimer

A smart contract security review can never verify the complete absence of vulnerabilities. This is a time, resource and expertise bound effort where I try to find as many vulnerabilities as possible. I can not guarantee 100% security after the review or even if the review will find any problems with your smart contracts.

# Claims Contract review 

**Scope: `Claims.sol`**

# [H-01] Arbitrary from in transferFrom

## Proof of Concept
Alice approves this contract to spend her ERC20 tokens. Bob can call ```transferFrom``` and specify Alice's address as the from parameter in transferFrom, allowing him to transfer Alice's tokens to himself.

## Impact

This can result in a user losing his/her tokens, which is a potential value loss. As the function is public and anyone can call it.

## Recommendation
Use msg.sender as from in ```transferFrom```.


# [M-01] The tokens will be stuck if the address is a contract which cannot handle ERC20 tokens. 

## Proof of Concept

The `trasnferFrom` function is using old way of transfering ERC20 token with no check of if the to address can handle ERC20 Tokens:
```solidity
    Line:99# require(
        _feeToken.transferFrom(feePayer, referrer, referrerCommission),
        "ERC721: Must have approval for referrer commission transfer"
    );
    Line:106# require(
        _feeToken.transferFrom(feePayer, _feeRecipient, remainingFee),
        "ERC721: Must have approval for fee transfer"
    );
```
This means that if the contract that has no ERC20 implementaion and it calls this functions will have token stuck in that contract forever.

## Impact

This can result in a user losing his/her tokens, which is a potential value loss. It requires the user to be using a smart contract that does not handle ERC20 properly, so it is Medium severity.

## Recommendation

Better way is to use SafeERC20 Library which helps validate all these points.

# Gas optimisation report

## [G-01] Replace require + string combination with custom errors for more robust and gas-efficient error handling in Solidity 0.8.4 and later

Remove require + string combination with custom errors which is more robust and gas efficient way for handling errors in solidity versions after 0.8.4

```solidity
        Line:72, Line:99, Line:117, Line:123
        require(_exists(tokenId), "ERC721: Token ID does not exist");
        
        Line:84
        require(
            _approvedFeePayers[tokenId][feePayer],
            "ERC721: Fee payer has not approved this token ID"
        );
        Line:99
        require(
            _feeToken.transferFrom(feePayer, referrer, referrerCommission),
            "ERC721: Must have approval for referrer commission transfer"
        );
        Line:106
        require(
            _feeToken.transferFrom(feePayer, _feeRecipient, remainingFee),
            "ERC721: Must have approval for fee transfer"
        );
        Line:139
        require(
            newTransferFee <= 125,
            "ERC721: Transfer fee cannot be more than 1.25%"
        );
```
