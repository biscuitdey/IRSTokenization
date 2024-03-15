const { expect } = require('chai');

describe('IRSwap contract', function () {
  it('Should deploy contract, create a swap and execute swap', async function () {
    const [floatRate_Account, fixedRate_Account, bank] = await ethers.getSigners();

    const initialUsdtBalance = 500000;
    const swapContractId = 1;
    const notional = 10000000; // 10 million dollars
    const fixedRate = 5; // 2%
    const cashFlowDate = 1; // for now, it isn't being used

    const irswap = await ethers.deployContract('IRSwap');

    // deploy usdt contract
    const usdtMock = await ethers.deployContract('USDT');
    await usdtMock.mint(floatRate_Account, initialUsdtBalance);
    await usdtMock.mint(fixedRate_Account, initialUsdtBalance);
    // give allowance to irswap contract

    await usdtMock.connect(floatRate_Account).approve(irswap, initialUsdtBalance);
    await usdtMock.connect(fixedRate_Account).approve(irswap, initialUsdtBalance);

    //create a swap contract
    await irswap.createSwapContract(
      swapContractId,
      notional,
      floatRate_Account,
      fixedRate_Account,
      fixedRate,
      usdtMock,
      cashFlowDate,
    );

    await irswap.executeSwap(swapContractId);
  });
});
