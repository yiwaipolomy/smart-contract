pragma solidity ^0.5.7;

interface TubInterface {
    function open() external returns (bytes32);
    function join(uint) external;
    function exit(uint) external;
    function lock(bytes32, uint) external;
    function free(bytes32, uint) external;
    function draw(bytes32, uint) external;
    function wipe(bytes32, uint) external;
    function give(bytes32, address) external;
    function shut(bytes32) external;
    function cups(bytes32) external view returns (address, uint, uint, uint);
    function gem() external view returns (TokenInterface);
    function gov() external view returns (TokenInterface);
    function skr() external view returns (TokenInterface);
    function sai() external view returns (TokenInterface);
    function ink(bytes32) external view returns (uint);
    function tab(bytes32) external returns (uint);
    function rap(bytes32) external returns (uint);
    function per() external view returns (uint);
    function pep() external view returns (PepInterface);
}

interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}

interface PepInterface {
    function peek() external returns (bytes32, bool);
}

interface MakerOracleInterface {
    function read() external view returns (bytes32);
}

interface UniswapExchange {
    function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
    function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
    function tokenToTokenSwapOutput(
        uint256 tokensBought,
        uint256 maxTokensSold,
        uint256 maxEthSold,
        uint256 deadline,
        address tokenAddr
        ) external returns (uint256  tokensSold);
}

interface BridgeInterface {
    function transferDAI(uint) external;
    function transferBackDAI(uint) external;
    function cArrLength() external view returns (uint);
    function cTokenAddr(uint) external view returns (address, uint);
}

interface CTokenInterface {
    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);
    function liquidateBorrow(address borrower, address cTokenCollateral) external payable;
    function exchangeRateCurrent() external returns (uint);
    function getCash() external view returns (uint);
    function totalBorrowsCurrent() external returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function totalReserves() external view returns (uint);
    function reserveFactorMantissa() external view returns (uint);
    function borrowBalanceCurrent(address account) external returns (uint);

    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256 balance);
    function allowance(address, address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface CERC20Interface {
    function mint(uint mintAmount) external returns (uint); // For ERC20
    function repayBorrow(uint repayAmount) external returns (uint); // For ERC20
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint); // For ERC20
    function borrowBalanceCurrent(address account) external returns (uint);
}

interface CETHInterface {
    function mint() external payable; // For ETH
    function repayBorrow() external payable; // For ETH
    function repayBorrowBehalf(address borrower) external payable; // For ETH
    function borrowBalanceCurrent(address account) external returns (uint);
}

interface ERC20Interface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function exitMarket(address cTokenAddress) external returns (uint);
    function getAssetsIn(address account) external view returns (address[] memory);
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
}

interface CompOracleInterface {
    function getUnderlyingPrice(address) external view returns (uint);
}


contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}


contract Helper is DSMath {

    /**
     * @dev get ethereum address for trade
     */
    function getAddressETH() public pure returns (address eth) {
        eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

    /**
     * @dev get MakerDAO CDP engine
     */
    function getSaiTubAddress() public pure returns (address sai) {
        sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
    }

    /**
     * @dev get MakerDAO Oracle for ETH price
     */
    function getOracleAddress() public pure returns (address oracle) {
        oracle = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
    }

    /**
     * @dev get uniswap MKR exchange
     */
    function getUniswapMKRExchange() public pure returns (address ume) {
        ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
    }

    /**
     * @dev get uniswap DAI exchange
     */
    function getUniswapDAIExchange() public pure returns (address ude) {
        ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
    }

    /**
     * @dev get uniswap DAI exchange
     */
    function getBridgeAddress() public pure returns (address bridge) {
        bridge = 0x9807554C441Bb37F549fc7F77165E5be49e55eD5;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getComptrollerAddress() public pure returns (address troller) {
        troller = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getCompOracleAddress() public pure returns (address troller) {
        troller = 0xe7664229833AE4Abf4E269b8F23a86B657E2338D;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getCETHAddress() public pure returns (address cEth) {
        cEth = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getDAIAddress() public pure returns (address dai) {
        dai = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getCDAIAddress() public pure returns (address cDai) {
        cDai = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
    }

    /**
     * @dev get CDP bytes by CDP ID
     */
    function getCDPBytes(uint cdpNum) public pure returns (bytes32 cup) {
        cup = bytes32(cdpNum);
    }

    /**
     * @dev setting allowance to compound for the "user proxy" if required
     */
    function setApproval(address erc20, uint srcAmt, address to) internal {
        TokenInterface erc20Contract = TokenInterface(erc20);
        uint tokenAllowance = erc20Contract.allowance(address(this), to);
        if (srcAmt > tokenAllowance) {
            erc20Contract.approve(to, 2**255);
        }
    }

}


contract MakerHelper is Helper {

    event LogOpen(uint cdpNum, address owner);
    event LogLock(uint cdpNum, uint amtETH, uint amtPETH, address owner);
    event LogFree(uint cdpNum, uint amtETH, uint amtPETH, address owner);
    event LogDraw(uint cdpNum, uint amtDAI, address owner);
    event LogWipe(uint cdpNum, uint daiAmt, uint mkrFee, uint daiFee, address owner);
    event LogShut(uint cdpNum);

    function getCDPStats(bytes32 cup) public view returns (uint ethCol, uint daiDebt) {
        TubInterface tub = TubInterface(getSaiTubAddress());
        (, uint pethCol, uint debt,) = tub.cups(cup);
        ethCol = rmul(pethCol, tub.per()); // get ETH col from PETH col
        daiDebt = debt;
    }

    /**
     * @dev get final Ratio of Maker CDP
     * @param ethCol amount of ETH Col to add in existing Col
     * @param daiDebt amount of DAI Debt to add in existing Debt
     */
    function getMakerRatio(bytes32 cup, uint ethCol, uint daiDebt) public view returns (uint ratio) {
        (uint makerCol, uint makerDebt) = getCDPStats(cup);
        makerCol += ethCol;
        makerDebt += daiDebt;
        uint usdPerEth = uint(MakerOracleInterface(getOracleAddress()).read());
        uint makerColInUSD = wmul(makerCol, usdPerEth);
        ratio = wdiv(makerDebt, makerColInUSD);
    }

    function setMakerAllowance(TokenInterface _token, address _spender) internal {
        if (_token.allowance(address(this), _spender) != uint(-1)) {
            _token.approve(_spender, uint(-1));
        }
    }

}


contract CompoundHelper is MakerHelper {

    event LogMint(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogRedeem(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogBorrow(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogRepay(address erc20, address cErc20, uint tokenAmt, address owner);

    function enterMarket(address cErc20) internal {
        ComptrollerInterface troller = ComptrollerInterface(getComptrollerAddress());
        address[] memory markets = troller.getAssetsIn(address(this));
        bool isEntered = false;
        for (uint i = 0; i < markets.length; i++) {
            if (markets[i] == cErc20) {
                isEntered = true;
            }
        }
        if (!isEntered) {
            address[] memory toEnter = new address[](1);
            toEnter[0] = cErc20;
            troller.enterMarkets(toEnter);
        }
    }

}


contract MakerResolver is CompoundHelper {

    function open() internal returns (uint) {
        bytes32 cup = TubInterface(getSaiTubAddress()).open();
        emit LogOpen(uint(cup), address(this));
        return uint(cup);
    }

    /**
     * @dev transfer CDP ownership
     */
    function give(uint cdpNum, address nextOwner) internal {
        TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
    }

    function wipe(uint cdpNum, uint _wad) internal returns (uint daiAmt) {
        if (_wad > 0) {
            TubInterface tub = TubInterface(getSaiTubAddress());
            UniswapExchange daiEx = UniswapExchange(getUniswapDAIExchange());
            UniswapExchange mkrEx = UniswapExchange(getUniswapMKRExchange());
            ERC20Interface dai = tub.sai();
            ERC20Interface mkr = tub.gov();

            bytes32 cup = bytes32(cdpNum);

            (address lad,,,) = tub.cups(cup);
            require(lad == address(this), "cup-not-owned");

            setMakerAllowance(dai, getSaiTubAddress());
            setMakerAllowance(mkr, getSaiTubAddress());
            setMakerAllowance(dai, getUniswapDAIExchange());

            (bytes32 val, bool ok) = tub.pep().peek();

            // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
            uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));

            uint daiFeeAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
            daiAmt = add(_wad, daiFeeAmt);

            // redeemUnderlying(getCDAIAddress(), daiAmt);

            if (ok && val != 0) {
                daiEx.tokenToTokenSwapOutput(
                    mkrFee,
                    daiAmt,
                    uint(999000000000000000000),
                    uint(1899063809), // 6th March 2030 GMT // no logic
                    address(mkr)
                );
            }

            tub.wipe(cup, _wad);

            emit LogWipe(
                cdpNum,
                daiAmt,
                mkrFee,
                daiFeeAmt,
                address(this)
            );

        }
    }

    function free(uint cdpNum, uint jam) internal {
        if (jam > 0) {
            bytes32 cup = bytes32(cdpNum);
            address tubAddr = getSaiTubAddress();

            TubInterface tub = TubInterface(tubAddr);
            ERC20Interface peth = tub.skr();
            ERC20Interface weth = tub.gem();

            uint ink = rdiv(jam, tub.per());
            ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
            tub.free(cup, ink);

            setMakerAllowance(peth, tubAddr);

            tub.exit(ink);
            uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
            weth.withdraw(freeJam);
        }
    }

    function lock(uint cdpNum, uint ethAmt) internal {
        if (ethAmt > 0) {
            bytes32 cup = bytes32(cdpNum);
            address tubAddr = getSaiTubAddress();

            TubInterface tub = TubInterface(tubAddr);
            ERC20Interface weth = tub.gem();
            ERC20Interface peth = tub.skr();

            (address lad,,,) = tub.cups(cup);
            require(lad == address(this), "cup-not-owned");

            weth.deposit.value(ethAmt)();

            uint ink = rdiv(ethAmt, tub.per());
            ink = rmul(ink, tub.per()) <= ethAmt ? ink : ink - 1;

            setMakerAllowance(weth, tubAddr);
            tub.join(ink);

            setMakerAllowance(peth, tubAddr);
            tub.lock(cup, ink);
        }
    }

    function draw(uint cdpNum, uint _wad) internal {
        bytes32 cup = bytes32(cdpNum);
        if (_wad > 0) {
            TubInterface tub = TubInterface(getSaiTubAddress());

            tub.draw(cup, _wad);
        }
    }

    function checkCDP(bytes32 cup, uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
        TubInterface tub = TubInterface(getSaiTubAddress());
        ethCol = rmul(tub.ink(cup), tub.per()); // get ETH col from PETH col
        daiDebt = tub.tab(cup);
        daiDebt = daiAmt < daiDebt ? daiAmt : daiDebt; // if DAI amount > max debt. Set max debt
        ethCol = ethAmt < ethCol ? ethAmt : ethCol; // if ETH amount > max Col. Set max col
    }

    function wipeAndFree(uint cdpNum, uint jam, uint _wad) internal returns (uint daiAmt) {
        daiAmt = wipe(cdpNum, _wad);
        free(cdpNum, jam);
    }

    function lockAndDraw(uint cdpNum, uint jam, uint _wad) internal {
        lock(cdpNum, jam);
        draw(cdpNum, _wad);
    }

}


contract CompoundResolver is MakerResolver {

    /**
     * @dev Deposit ETH and mint Compound Tokens
     */
    function mintCEth(uint tokenAmt) internal {
        enterMarket(getCETHAddress());
        CETHInterface cToken = CETHInterface(getCETHAddress());
        cToken.mint.value(tokenAmt)();
        emit LogMint(
            getAddressETH(),
            getCETHAddress(),
            tokenAmt,
            msg.sender
        );
    }

    /**
     * @dev borrow DAI
     */
    function borrowDAIComp(uint tokenAmt) internal {
        enterMarket(getCDAIAddress());
        require(CTokenInterface(getCDAIAddress()).borrow(tokenAmt) == 0, "got collateral?");
        setApproval(getDAIAddress(), tokenAmt, getBridgeAddress());
        BridgeInterface(getBridgeAddress()).transferBackDAI(tokenAmt);
        emit LogBorrow(
            getDAIAddress(),
            getCDAIAddress(),
            tokenAmt,
            address(this)
        );
    }

    /**
     * @dev Pay DAI Debt
     */
    function repayDaiComp(uint tokenAmt) internal returns (uint wipeAmt) {
        CERC20Interface cToken = CERC20Interface(getCDAIAddress());
        uint daiBorrowed = cToken.borrowBalanceCurrent(address(this));
        wipeAmt = tokenAmt;
        if (tokenAmt > daiBorrowed) {
            wipeAmt = daiBorrowed;
        }
        // BridgeInterface(getBridgeAddress()).transferDAI(wipeAmt);
        setApproval(getDAIAddress(), wipeAmt, getCDAIAddress());
        require(cToken.repayBorrow(wipeAmt) == 0, "transfer approved?");
        emit LogRepay(
            getDAIAddress(),
            getCDAIAddress(),
            wipeAmt,
            address(this)
        );
    }

    /**
     * @dev Redeem CETH
     * @param tokenAmt Amount of token To Redeem
     */
    function redeemCETH(uint tokenAmt) internal {
        CTokenInterface cToken = CTokenInterface(getCETHAddress());
        uint cethBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint cethInEth = wmul(cethBal, exchangeRate);
        setApproval(getCETHAddress(), 2**128, getCETHAddress());
        uint ethAmtReddemed = tokenAmt;
        if (tokenAmt > cethInEth) {
            require(cToken.redeem(cethBal) == 0, "something went wrong");
            ethAmtReddemed = cethInEth;
        } else {
            require(cToken.redeemUnderlying(tokenAmt) == 0, "something went wrong");
        }
        emit LogRedeem(
            getAddressETH(),
            getCETHAddress(),
            ethAmtReddemed,
            address(this)
        );
    }

}


contract Bridge is CompoundResolver {

    /**
     * @dev convert Maker CDP into Compound Collateral
     * @param toConvert ranges from 0 to 1 and has (18 decimals)
     */
    function makerToCompound(uint cdpId, uint toConvert) public {
        bytes32 cup = bytes32(cdpId);
        (uint ethCol, uint daiDebt) = getCDPStats(cup);
        uint ethFree = ethCol;
        uint daiAmt = daiDebt;
        if (toConvert < 10**18) {
            uint wipeAmt = wmul(daiDebt, toConvert);
            ethFree = wmul(ethCol, toConvert);
            daiAmt = wipe(cup, wipeAmt, ethFree);
            free(cup, ethFree);
        } else {
            daiAmt = shut(cup);
        }
        mintCEth(ethFree);
        borrowDAIComp(daiAmt);
    }

    /**
     * @dev convert Compound Collateral into Maker CDP
     * @param cdpId = 0, if user don't have any CDP
     * @param toConvert ranges from 0 to 1 and has (18 decimals)
     */
    function compoundToMaker(uint cdpId, uint toConvert) public {
        bytes32 cup = bytes32(cdpId);
        if (cdpId == 0) {
            cup = open();
        }

        (uint ethCol, uint daiDebt,, uint totalBorrow, uint maxBorrow, uint daiInEth) = getCompoundStats(address(this));
        uint ethFree = ethCol;
        uint daiAmt = daiDebt;
        if (toConvert < 10**18) {
            daiAmt = wmul(daiDebt, toConvert);
            ethFree = wmul(ethCol, toConvert);
        }
        uint makerFinalRatio = getMakerRatio(cup, ethFree, daiAmt);
        require(makerFinalRatio < 660000000000000000, "Maker CDP will liquidate");
        totalBorrow -= wmul(daiAmt, daiInEth);
        maxBorrow -= wmul(ethFree, 750000000000000000);
        require(totalBorrow < maxBorrow, "Compound position will liquidate");
        repayToken(daiAmt);
        redeemUnderlying(ethFree);
        lock(cup, ethFree);
        draw(cup, daiAmt);
    }

}


contract InstaBridge is Bridge {

    uint public version;

    /**
     * @dev setting up variables on deployment
     * 1...2...3 versioning in each subsequent deployments
     */
    constructor(uint _version) public {
        version = _version;
    }

    function() external payable {}

}