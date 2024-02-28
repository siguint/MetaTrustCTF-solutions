// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

interface IVault {
    function createMyNode(uint256 _nodeId, uint256 _rewardRateBase, uint256 _rewardFactor) external;
    function purchaseForOwner() external;
    function depositOnce(uint256 _nodeId) external payable;
    function emergencyWithdraw(uint256 _nodeId) external;
    function calculateForRewardRate(uint256 _rewardRateBase) external returns (uint256);
}

contract vaultTest is Test {
    IVault public vault;

    function setUp() public {
        bytes memory code = hex"6003361161000c576104d1565b60003560e01c636fb31a2081186101505760243610610690576000546002146106905760026000556007336020526000526040600020546106905734156106905760056004356020526000526040600020541561069057600733602052600052604060002080546001810181811061069057905081555060043560405261009360e061067a565b60e0516101205260016101405261012051604052610140516060526100b96101006104d7565b6101005160c0523460c051808202811583838304141715610690579050905047808202811583838304141715610690579050905060e05260063360205260005260406000208060043560205260005260406000209050805460e05180820182811061069057905090508155506004336020526000526040600020805460e05180820182811061069057905090508155506003600055005b34610690576364d98f6e811861017457600436106106905760025460405260206040f35b6376c0f803811861019d5760643610610690576024356005600435602052600052604060002055005b631f34045981186101ba57600436106106905760016040526101d4565b63af8d446981186102cc5760243610610690576004356040525b6014606052604036608037600a604051111561029257600b60405110156101fc576000610204565b601460405111155b61024d576060516005810281600582041861069057905060a05260a0516040516005810181811061069057905080820281158383830414171561069057905090506080526102c6565b6060518060021b818160021c1861069057905060a05260a0516040516005810381811161069057905080820281158383830414171561069057905090506080526102c6565b6060516003810281600382041861069057905060a05260a05160405180820281158383830414171561069057905090506080525b60206080f35b6318c89d8e811861032457600436106106905742629896808102816298968082041861069057905060043360205260005260406000205418610690573360015560016002556000600433602052600052604060002055005b635312ea8e81186103835760243610610690576000546002146106905760026000556006336020526000526040600020806004356020526000526040600020905054156106905760006004336020526000526040600020556003600055005b638da5cb5b81186103a257600436106106905760015460405260206040f35b6302f739c081186103c157600436106106905760025460405260206040f35b6339a6239581186103e057600436106106905760035460405260206040f35b63fc7e286d811861041b5760243610610690576004358060a01c61069057604052600460405160205260005260406000205460605260206060f35b637b809edf8118610448576024361061069057600560043560205260005260406000205460405260206040f35b63adf1b67e81186104945760443610610690576004358060a01c610690576040526006604051602052600052604060002080602435602052600052604060002090505460605260206060f35b63adc080d981186104cf5760243610610690576004358060a01c61069057604052600760405160205260005260406000205460605260206060f35b505b60006000fd5b604036608037600a604051111561061757600b60405110156104fa576000610502565b601460405111155b610598576015606051101561052c576060516005810281600582041861069057905060a052610569565b601e6060511115610552576060516007810281600782041861069057905060a052610569565b6060516006810281600682041861069057905060a0525b60a051604051600581018181106106905790508082028115838383041417156106905790509050608052610672565b600b60605110156105aa5760006105b2565b601460605111155b6105d1576060516005810281600582041861069057905060a0526105e8565b6060518060021b818160021c1861069057905060a0525b60a051604051600581038181116106905790508082028115838383041417156106905790509050608052610672565b600f606051111561063d576060516003810281600382041861069057905060a052610654565b6060518060011b818160011c1861069057905060a0525b60a05160405180820281158383830414171561069057905090506080525b608051815250565b6005604051602052600052604060002054815250565b600080fda165767970657283000307000b";
        address deployed;
        assembly {
            deployed := create(0, add(code, 0x20), mload(code))
            if iszero(extcodesize(deployed)) {
                revert(0, 0)
            }
        }
        vault = IVault(deployed);
    }

    function test_VaultSolution() public {
        vm.warp(1709062692);
        // uint value = 0;
        uint x = 1;
        uint value = 10000000 * block.timestamp / (vault.calculateForRewardRate(x));
        console2.log(value);

    }
}

