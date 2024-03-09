// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.13;

import {SECP256R1_Verify} from "ECDSA_Solidity/contracts/Verify.sol";

contract VerifyTest {
    SECP256R1_Verify public verify;

    function setUp() public {
        verify = new SECP256R1_Verify();
    }

    function test_ECDSASolution() public {
        this.setUp();
        uint r = 0x8ca09723f24865bbc3fd194cc60cc95a77943ed5b38671887007072ba917a5ea;
        uint s = 0xb36a63f0329d0ad45be9bbdea6f62508a9add0d79c51c97adc11dfb720cad37a;
        verify.solve(r, s);
        require(verify.isSolved() == true);

    }
}

