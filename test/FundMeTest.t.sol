// SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testOwnerisMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
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
}
