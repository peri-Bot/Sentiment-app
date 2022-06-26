//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
error MarketSentiment__NotOwner();

contract MarketSentiment {
    address private immutable i_Owner;
    string[] public tickerArray;
    mapping(string => Ticker) private Tickers;

    constructor() {
        i_Owner = msg.sender;
    }

    struct Ticker {
        bool exists;
        uint256 up;
        uint256 down;
        mapping(address => bool) voters;
    }

    event UpdateTicker(uint256 up, uint256 down, address voter, string ticker);

    modifier onlyOwner() {
        if (msg.sender != i_Owner) {
            revert MarketSentiment__NotOwner();
        }
        _;
    }

    function addTicker(string memory _ticker) public onlyOwner {
        Ticker storage newTicker = Tickers[_ticker];
        newTicker.exists = true;
        tickerArray.push(_ticker);
    }

    function vote(string memory _ticker, bool _vote) public {
        require(Tickers[_ticker].exists, "Can't vote on this coin!");
        require(
            !Tickers[_ticker].voters[msg.sender],
            "Already voted for this coin!"
        );

        Ticker storage t = Tickers[_ticker];
        t.voters[msg.sender] = true;

        if (_vote) {
            t.up++;
        } else {
            t.down++;
        }

        emit UpdateTicker(t.up, t.down, msg.sender, _ticker);
    }

    function getVotes(string memory _tickers)
        public
        view
        returns (uint256 up, uint256 down)
    {
        require(Tickers[_tickers].exists, "No such ticker Defined");
        Ticker storage t = Tickers[_tickers];

        return (t.up, t.down);
    }
}
