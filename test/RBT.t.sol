// SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.6.12;
// import "forge-std/Test.sol";
// import "../src/BokkyPooBahsRedBlackTreeLibrary.sol";
// contract RedBlackTest is Test {
//     using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;
//     BokkyPooBahsRedBlackTreeLibrary.Tree tree;

pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/RBTLib.sol";
contract RedBlackTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;
    RedBlackTreeLib.Tree tree;


    function insert(uint val) internal returns(uint){
        // uint tree_size = tree.size();
        uint tree_size = 0;
        uint GAS_BEFORE = gasleft();
        tree.insert(val);
        uint GAS_AFTER = gasleft();
        // console.log(string.concat("Tree size - ",uint2str(tree_size)," | Gas used after inserting -> ",uint2str(val)),GAS_BEFORE - GAS_AFTER);
        console.log(string(abi.encodePacked("Tree size - ",uint2str(tree_size)," | Gas used after inserting -> ",uint2str(val))),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }

    function remove(uint val) internal returns(uint){
        // uint tree_size = tree.size();
        uint tree_size = 0;
        uint GAS_BEFORE = gasleft();
        tree.remove(val);
        uint GAS_AFTER = gasleft();
        console.log(string(abi.encodePacked("Tree size - ",uint2str(tree_size)," | Gas used after removing -> ",uint2str(val))),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }


    function testFirst() public {
        uint total_gas_used;
        uint N = 1;
        for (uint i ;i<N;i++){
            total_gas_used += insert(uint256(keccak256(abi.encode(i))));
        }
        console.log(string(abi.encodePacked("Total gas used for inserting ",uint2str(N)," items")),total_gas_used);
        // console.log("Gas used after inserting all ", GASLEFT - gasleft());
        // tree.print();

        // remove(15);

        // remove(19);
        // // tree.print();

        // insert(100);
        // // tree.print();

        // remove(12);
        // tree.print();
    }

    uint[] public seq_inp_arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32];
    // function testSequential() public {
    //     for (uint i;i<seq_inp_arr.length;i++){
    //         tree.insert(seq_inp_arr[i]);
    //     }
    //     // tree.print();
    // }
    // function testSecond() public {
    //     tree.insert(100);
    // }

    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString){
        if (_i == 0) {
            return '0';
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}


// pragma solidity ^0.6.12;
// import "forge-std/Test.sol";
// import "../src/BokkyPooBahsRedBlackTreeLibrary.sol";
// contract RedBlackTest is Test {
//     using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;
//     BokkyPooBahsRedBlackTreeLibrary.Tree tree;
