// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
// This contract represents IRS cashflow 
contract IRSwap {
    struct SWAP {
        uint256 notional; // total amount
        address floatRate_Account; // float rate address to receive funds
        address fixedRate_Account; // fixed rate address to receive funds
        uint256 fixedRate; // fixed rate
        IERC20 usdt; // USDT
        uint256 cashFlowDate; // timestamp
    }

    mapping(uint256 => SWAP) public swapContracts;

    uint256 public swapFee = 1;
    address public feeAccount = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    uint256 public benchmark = 2; // float rate set every day at 8:30 am

    uint256 public MONTH_IN_SECONDS = 10;

    function createSwapContract(
        uint256 id,
        uint256 notional,
        address floatRate_Account,
        address fixedRate_Account,
        uint256 fixedRate,
        address usdt,
        uint256 cashFlowDate
    ) external {
        swapContracts[id] = SWAP(
            notional,
            floatRate_Account,
            fixedRate_Account,
            fixedRate,
            IERC20(usdt),
            cashFlowDate + MONTH_IN_SECONDS
        );
    }

    // calculate swap. get float rate.
    function executeSwap(uint256 id) external {
        SWAP storage swap = swapContracts[id];

        // check if swap was executed already or the time and date is valid (can be executed)
        //require(swap.cashFlowDate < block.timestamp);

        // can be executed again in 30 days
        swap.cashFlowDate = block.timestamp + MONTH_IN_SECONDS;

        uint256 fee = ((swap.notional * swapFee) / 1000) / 2;

        uint256 fixedAmount = ((swap.notional * swap.fixedRate) / 100) - fee;
        uint256 floatAmount = ((swap.notional * benchmark) / 100) - fee;

        console.log("Fee: ", fee);
        console.log("Fixed Amount: ", fixedAmount);
        console.log("Float amount: ", floatAmount);

        //transferFrom(address from, address to, uint256 value) external returns (bool);
        //fixed receives float
        swap.usdt.transferFrom(
            swap.floatRate_Account,
            swap.fixedRate_Account,
            floatAmount
        );

        // float receives fixed amount
        swap.usdt.transferFrom(
            swap.fixedRate_Account,
            swap.floatRate_Account,
            fixedAmount
        );

        // pay fee
        swap.usdt.transferFrom(swap.fixedRate_Account, feeAccount, fee);
        swap.usdt.transferFrom(swap.floatRate_Account, feeAccount, fee);
    }

    function updateBenchMarck(uint256 newBenchmark) external {
        benchmark = newBenchmark;
    }
    // create function to update floatRate
}
