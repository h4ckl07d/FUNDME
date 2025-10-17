// SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testOwnerisMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testMinimumDollarisfive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Types of Testing
    // 1.Unit
    //      -Testing a specific part of our code
    // 2. Integration
    //      -Testing how the code code works with other part of the code
    // 3. Forked
    //      -Testing the code in  a simmulated real environment
    // 4. Staging
    //      -Testing our code in a real environemnt thatv is not in prduction

    function testversion() public view {
        uint256 version = fundMe.getVersion();
        // console.log(fundMe.getVersion());
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); //Next line should revert
        fundMe.fund(); // sending 0 value for it to work
        // It worked because the value is lesser than the Minimum Usd specified in the contract
    }

    function testFundUpdatesFundedArray() public {
        vm.prank(USER); // The next tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFunderToArrayofFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert(); //Next line should revert because USER is not the owner hence test passed
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint256 i = startingFunderIndex; i < numberOfFunders; i++) {
            address funder = address(uint160(i)); // Generate unique funder address
            vm.deal(funder, SEND_VALUE); // Assign Ether to the funder address
            vm.prank(funder); // Set the next transaction to be sent by the funder
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assertEq(address(fundMe).balance, 0); // Ensure contract balance is zero
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            fundMe.getOwner().balance
        ); // Ensure owner received all funds
    }
}
