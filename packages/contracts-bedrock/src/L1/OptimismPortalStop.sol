// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {OptimismPortal} from './OptimismPortal.sol';

contract OptimismPortalStop is OptimismPortal {
    address public immutable privilegedAddress;

    constructor(
        L2OutputOracle _l2Oracle,
        SystemConfig _systemConfig,
        address _privilegedAddress
    ) OptimismPortal(_l2Oracle, _systemConfig) {
        privilegedAddress = _privilegedAddress;
    }

    function depositTransaction(
        address _to,
        uint256 _value,
        uint64 _gasLimit,
        bool _isCreation,
        bytes memory _data
    ) public payable override {
        revert('Deposits are disabled');
    }

    function withdrawETH(address _to, uint256 _amount) external {
        require(
            msg.sender == privilegedAddress,
            'Only privileged address can withdraw'
        );
        require(
            address(this).balance >= _amount,
            'Insufficient balance in contract'
        );

        payable(_to).transfer(_amount);
    }
}
