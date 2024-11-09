//SPDX-License Identifier: MIT
pragma solidity ^0.8.18;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
    }

    function increaseAllowance(address spender, uint256 addedValue) public {
        uint256 newAllowance = allowance(msg.sender, spender) + addedValue;
        _approve(msg.sender, spender, newAllowance);
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public {
        uint256 newsubtractedAllowance = allowance(msg.sender, spender) -
            subtractedValue;
        _approve(msg.sender, spender, newsubtractedAllowance);
    }
}
