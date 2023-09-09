// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Main.sol";
import "../src/mocks/MockTarget.sol";

contract MainTest is Test {
    MockTarget mt;
    ProxyContract pc;
    address developer = makeAddr("DEV");

    function setUp() public {
        vm.startPrank(developer);
        mt = new MockTarget();
        pc = new ProxyContract();
        vm.stopPrank();
    }

    function test_registerUser() public {
        address alice = makeAddr("ALICE");
        
        vm.prank(developer);
        pc.registerUser(alice);
        
        bool succ;
        bytes memory res;
        vm.startPrank(alice);
        (succ, res) = pc.execute(address(mt), abi.encodeWithSelector(MockTarget.mockFunctionSuccess.selector));
        assertEq(succ, true);
        assertEq(abi.decode(res, (bool)), true);
        (succ, res) = pc.execute(address(mt), abi.encodeWithSelector(MockTarget.mockFunctionRevert.selector));
        assertEq(succ, true);
        vm.stopPrank();
    }
}
