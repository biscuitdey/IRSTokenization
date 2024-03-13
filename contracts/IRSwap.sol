pragma solidity ^0.8.0;


contract IRSwap  {

    struct SWAP {
        uint256 notional;           // total amount
        address floatRate_Account;  // float rate address to receive funds
        address fixedRate_Account;  // fixed rate address to receive funds
        uint256 fixedRate;          // fixed rate
        uint256 fee;                // contract fee
        address assetContract;      // USDT
        uint256 startDate;          // timestamp
    }

    struct RateContract {
        uint256 notional;       // total amount
        address owner;          // to receive funds
        uint256 rate;           // fix rate
        bool hasSwap;           // true if a swap was set
        //uint256 initialPayment; // timestamp of the first swap. the others would happen after 30 days. 
    }

    mapping(uint256 => RateContract) public fixed_RateContracts;
    mapping(uint256 => RateContract) public float_RateContracts;

    mapping(uint256 => SWAP) public swapContracts;

    uint256 public swapFee;
    address public feeAccount;
    uint256 public floatRate;  // float rate set every day at 8:30 am

    function add_fixed_RateContract(uint256 id, uint256 notional, address owner, uint256 fixedRate) external {
        fixed_RateContracts[id] = RateContract(notional,owner,fixedRate, false);
    }

    function add_float_RateContract(uint256 id, uint256 notional, address owner, uint256 floateRate) external {
        float_RateContracts[id] = RateContract(notional,owner,floateRate, false);
    }

    // calculate swap. get float rate.
    function executeSwap(uint256 id) external{
        SWAP memory swap = swapContracts[id];
        
        // check if swap was executed already or the time and date is valid (can be executed)

        // set swap for that payment day is done

        uint256 fixedAmount = swap.notional * swap.fixedRate - swap.notional * swapFee;
        uint256 floatAmount = swap.notional * floatRate - swap.notional * swapFee;

        if(fixedAmount == floatAmount) {
            // do nothing
        } else {
            // transfer fixed amount to the float account
            
            // transfer float amount to the fixed account

            // transfer fee to the fee account
        }
 
        // event swap was executed
    }

    // create function to update floatRate

}
