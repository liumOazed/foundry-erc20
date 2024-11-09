//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokentest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);

        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        // Bob approve Alice to spend on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        vm.prank(alice);
        uint256 transferAmount = 500;
        ourToken.transferFrom(bob, alice, transferAmount); // difference between transfer and transferFrom

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testApproveAndCheckAllowance() public {
        // Arrange
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        // Act
        uint256 allowance = ourToken.allowance(bob, alice);

        // Assert
        assertEq(allowance, initialAllowance);
    }

    function testIncreaseAllowance() public {
        // Arrange
        uint256 initialAllowance = 1000;
        uint256 increaseAmount = 500;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        // Act
        vm.prank(bob);
        ourToken.increaseAllowance(alice, increaseAmount);

        // Assert
        assertEq(
            ourToken.allowance(bob, alice),
            initialAllowance + increaseAmount
        );
    }

    function testDecreaseAllowance() public {
        // Arrange
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        // Act
        vm.prank(bob);
        ourToken.decreaseAllowance(alice, 300);

        // Assert
        assertEq(ourToken.allowance(bob, alice), initialAllowance - 300);
    }
}
