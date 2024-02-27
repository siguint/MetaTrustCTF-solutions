// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ByteDance} from "byteDance/contracts/byteDance.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

contract HuffDeploymentExample {
    function deploy() external returns(address) {
        return HuffDeployer.deploy("byteDance");
    }
}

contract byteDanceTest is Test {
    ByteDance public bytedance;
    HuffDeploymentExample public huff;

    function setUp() public {
        bytedance = new ByteDance();
        huff = new HuffDeploymentExample();
    }
    function test_ByteDanceSolution() public {
        vm.prank(address(0));
        address huffc = huff.deploy();
        bytedance.checkCode(huffc);
        assertTrue(bytedance.isSolved());
    }
}