// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BytecodeVault} from "byteVault/contracts/bytecodeVault.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

contract HuffDeploymentExample {
    function deploy() external returns(address) {
        return HuffDeployer.deploy("bytecodeVault");
    }
}
contract bytecodeVaultTest is Test {
    BytecodeVault public bytecodeVault;

    function setUp() public {
        bytecodeVault = new BytecodeVault();
    }

    function test_BytecodeVaultSolution() public {
        address huffc = new HuffDeploymentExample().deploy();
        (bool success,) = huffc.call(abi.encodeWithSignature("attack(address)", address(bytecodeVault)));
        assertTrue(success);
        assertTrue(bytecodeVault.isSolved());

    }
}

