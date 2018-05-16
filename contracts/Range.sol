pragma solidity ^0.4.21;

library Range {
    function isBetween(
        uint256 _subject,
        uint256 _start,
        uint256 _end
    ) internal pure returns (bool) {
        return (_start <= _subject && _subject < _end);
    }
}
