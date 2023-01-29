// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "forge-std/console.sol";
function bool2str(bool _i)  pure returns (string memory _uintAsString){
    return _i ? "TRUE" : "FALSE";
}

function uint2str(uint256 _i)  pure returns (string memory _uintAsString){
    return uint2str(_i,0);
}

function uint2str(uint256 _i,uint padding) pure returns (string memory _uintAsString){
    if (_i == 0) {
        return '0';
    }
    uint256 j = _i;
    uint256 len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    require(padding == 0 || padding >= len,"[ERR] uint2str()# padding < len ");
    uint out_len = padding == 0 ? len : padding ;
    bytes memory bstr = new bytes(out_len);
    uint256 k = out_len;
    while (_i != 0) {
        k = k - 1;
        uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
        bytes1 b1 = bytes1(temp);
        bstr[k] = b1;
        _i /= 10;
    }
    while(k != 0 ){
        k = k-1;
        bytes1 b1 = " ";
        bstr[k] = b1;
    }
    // console.log(padding,len,out_len,string(bstr));
    return string(bstr);
}