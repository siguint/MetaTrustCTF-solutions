// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Foo} from "Foo/contracts/Foo.sol";

contract FooTest is Test {
    Foo public foo;

    function setUp() public {
        foo = new Foo();
    }

    function test_FooSolution() public {
        skip(10000 days);
        FactoryAssembly f = new FactoryAssembly();
        Attack attack;
        for (uint i; i < 10000; i++) {
            bytes memory bytecode = f.getBytecode();
            address addr = f.getAddress(bytecode, i);
            uint256 check = uint256(uint160(addr));
            if (check % 1000 == 137) {
                f.deploy(bytecode, i);
                attack = Attack(addr);
                attack.setup(foo);
                break;
            }
        }

        attack.stage1{gas: 100000}(foo);
        attack.stage2(foo);
        attack.stage3(foo);

        uint mappingSlot = 1;
        uint key = 4;
        uint256 keySlot = uint256(keccak256(abi.encode(key, mappingSlot)));
        keySlot = uint256(keccak256(abi.encode(address(attack), keySlot)));
        uint sorted_value = uint(vm.load(address(foo), bytes32(keySlot)));
        attack.stage4(foo, keySlot);
        assertTrue(foo.isSolved());
    }
}

contract Attack {
    bytes32 public _check1;
    bytes32 public _check2;
    uint public sorted_value;

    event Gas(uint256 gas);
    constructor() {
        _check1 = keccak256(abi.encodePacked("1337"));
        _check2 = keccak256(abi.encodePacked("13337"));
    }
    function setup(Foo foo) external {
        foo.setup();
    }
    function stage1(Foo foo) external  {
        foo.stage1();
    }
    function stage2(Foo foo) external {
        foo.stage2{gas:40300}();
    }
    function stage3(Foo foo) external {
        uint timestamp = block.timestamp;
        uint[] memory challenge = new uint[](8);
        challenge[0] = (block.timestamp & 0xf0000000) >> 28;
        challenge[1] = (block.timestamp & 0xf000000) >> 24;
        challenge[2] = (block.timestamp & 0xf00000) >> 20;
        challenge[3] = (block.timestamp & 0xf0000) >> 16;
        challenge[4] = (block.timestamp & 0xf000) >> 12;
        challenge[5] = (block.timestamp & 0xf00) >> 8;
        challenge[6] = (block.timestamp & 0xf0) >> 4;
        challenge[7] = (block.timestamp & 0xf) >> 0;
        for(uint i=0 ; i<8 ; i++) {
            for(uint j=i+1 ; j<8 ; j++) {
                if (challenge[i] > challenge[j]) {
                    uint tmp = challenge[i];
                    challenge[i] = challenge[j];
                    challenge[j] = tmp;
                }
            }
        }
        sorted_value = challenge[7] + (challenge[6] << 4) +
                        (challenge[5] << 8) + (challenge[4] << 12) +
                        (challenge[3] << 16) + (challenge[2] << 20) +
                        (challenge[1] << 24) + (challenge[0] << 28);
        foo.stage3();
    }
    function stage4(Foo foo, uint _sorted_value) public {
        sorted_value = _sorted_value;
        foo.stage4();
    }
    function pos() external returns (bytes32) {
        return bytes32(sorted_value);
    }
    function sort(uint256[] calldata challenge) public view returns (uint[] memory) {
        uint _sorted_value = sorted_value;
        uint[] memory challenge = new uint[](8);
        challenge[0] = (_sorted_value & 0xf0000000) >> 28;
        challenge[1] = (_sorted_value & 0xf000000) >> 24;
        challenge[2] = (_sorted_value & 0xf00000) >> 20;
        challenge[3] = (_sorted_value & 0xf0000) >> 16;
        challenge[4] = (_sorted_value & 0xf000) >> 12;
        challenge[5] = (_sorted_value & 0xf00) >> 8;
        challenge[6] = (_sorted_value & 0xf0) >> 4;
        challenge[7] = (_sorted_value & 0xf) >> 0;
        return challenge;
    }

    function check() public returns (bytes32 check_) {
        uint256 gas = gasleft();
        if (gas > 73500) {
            check_ = _check1;
        } else {
            check_ = _check2;
        }
    }
}

// This is the older way of doing it using assembly
contract FactoryAssembly {
    event Deployed(address addr, uint256 salt);

    function getBytecode()
        public
        pure
        returns (bytes memory)
    {
        bytes memory bytecode = type(Attack).creationCode;
        return abi.encodePacked(bytecode);
    }

    function getAddress(bytes memory bytecode, uint256 _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff), address(this), _salt, keccak256(bytecode)
            )
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint256(hash)));
    }

    function deploy(bytes memory bytecode, uint256 _salt) public payable {
        address addr;

        assembly {
            addr :=
                create2(
                    callvalue(), // wei sent with current call
                    // Actual code starts after skipping the first 32 bytes
                    add(bytecode, 0x20),
                    mload(bytecode), // Load the size of code contained in the first 32 bytes
                    _salt // Salt from function arguments
                )

            if iszero(extcodesize(addr)) { revert(0, 0) }
        }

    }
}