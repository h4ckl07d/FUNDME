// SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundMe;

    function run() external returns (FundMe) {
        // Anything before startBroadcast --> Not a real Transaction
        HelperConfig helperconfig = new HelperConfig();
        address ethUsdPriceFeed = helperconfig.activeNetworkConfig();

        // Anything after startBroadcast --> a real Transaction
        //  0x694AA1769357215DE4FAC081bf1f309aDC325306
        vm.startBroadcast();
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
