// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Main.sol";

contract MainScript is Script {

    function run() public {
        uint256 devPk = vm.envUint("DEV_PK");
        
        vm.startBroadcast(devPk);
        ProxyContract pc = new ProxyContract();
        vm.stopBroadcast();
    }
}
