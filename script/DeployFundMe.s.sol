// SPDX-License-Identifier:MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundMe;

    function run() external returns (FundMe) {
        // Anything Before startBroadcast -> Not a "real" tx
        HelperConfig helperconfig = new HelperConfig();
        address ethUsdPriceFeed = helperconfig.activeNetworkConfig();

        // After Broadcast -> Real tx
        vm.startBroadcast();
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
