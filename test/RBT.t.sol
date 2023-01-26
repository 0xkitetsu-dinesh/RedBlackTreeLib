// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "../src/BokkyPooBahsRedBlackTreeLibrary.sol";
import "../src/RBTLib.sol";
contract RedBlackTest is Test {
    using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;
    using RedBlackTreeLib for RedBlackTreeLib.Tree;
    
    BokkyPooBahsRedBlackTreeLibrary.Tree BPBtree;
    RedBlackTreeLib.Tree RBtree;

    uint80 private constant EMPTY = 0;

    function check(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,RedBlackTreeLib.Tree storage rb_tree,uint val) internal {
        // console.log("checking ",val);
        (uint bpb_val,uint bpb_p,uint bpb_l,uint bpb_r,bool bpb_c) = bpb_tree.getNode(val);
        (uint rb_val,uint rb_p,uint rb_l,uint rb_r,bool rb_c) = rb_tree.getNode(val);

        // require(bpk_val == rb_val,"")
        require(bpb_p==rb_p,string.concat("parent mismatch ",uint2str(val)));
        require(bpb_l==rb_l,string.concat("left mismatch ",uint2str(val)));
        require(bpb_r==rb_r,string.concat("right mismatch ",uint2str(val)));
        require(bpb_c==rb_c,string.concat("color mismatch ",uint2str(val)));

        if(bpb_l == EMPTY && bpb_r == EMPTY) return;
        if(bpb_l != EMPTY) check(bpb_tree,rb_tree,bpb_l);
        if(bpb_r != EMPTY) check(bpb_tree,rb_tree,bpb_r);

    }
    function equal(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,RedBlackTreeLib.Tree storage rb_tree) internal returns(bool){
        assertEq(bpb_tree.root,rb_tree.getRoot(),"root mismatch");
        check(bpb_tree,rb_tree,bpb_tree.root);
        return true;
    }

    function insertRBtree(RedBlackTreeLib.Tree storage rb_tree,uint val,bool debug) internal returns(uint){
        uint tree_size = rb_tree.size();
        uint GAS_BEFORE = gasleft();
        rb_tree.insert(val);
        uint GAS_AFTER = gasleft();
        if (debug) console.log(string.concat("Tree size - ",uint2str(tree_size)," | Gas used after inserting -> ",uint2str(val)),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }
    function insertBPBtree(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,uint val,bool debug) internal returns(uint){
        uint GAS_BEFORE = gasleft();
        bpb_tree.insert(val);
        uint GAS_AFTER = gasleft();
        if (debug) console.log(string.concat(" | Gas used after inserting -> ",uint2str(val)),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }

    function testInsertN() public {
        uint gas_used_RB;uint gas_used_BPB;
        uint total_gas_used_RB;uint total_gas_used_BPB;

        uint N = 10000;
        uint element = 10;
        console.log("============= inserting ",N," elements (BPB,RB) =============",element);
        for (uint i ;i<N;i++){
            element = uint256(keccak256(abi.encodePacked(element)));
            bool debug = i == 0 || i ==10 || i == 100 || i == 1000  || i == N-1 ? true : false ;
            gas_used_RB = insertRBtree(RBtree,element,false);
            gas_used_BPB = insertBPBtree(BPBtree,element,false);

            if (debug) console.log(string.concat("gas used for inserting ",uint2str(i+1,6),"th item "/*,uint2str(element)*/),gas_used_BPB,gas_used_RB , 
                                    gas_used_BPB > gas_used_RB ? string.concat("-",uint2str(((gas_used_BPB - gas_used_RB) * 100) /  gas_used_BPB),"%") : string.concat("+",uint2str(((gas_used_RB - gas_used_BPB) * 100) /  gas_used_BPB),"%")
                                    );

            total_gas_used_RB += gas_used_RB ;
            total_gas_used_BPB += gas_used_BPB ;
        }
        console.log(string.concat("Total gas used for inserting ",uint2str(N)," items "),total_gas_used_BPB,total_gas_used_RB,
                    total_gas_used_BPB > total_gas_used_RB ? string.concat("-",uint2str(((total_gas_used_BPB - total_gas_used_RB) * 100) /  total_gas_used_BPB),"%") : string.concat("+",uint2str(((total_gas_used_RB - total_gas_used_BPB) * 100) /  total_gas_used_BPB),"%")
        );
        require(equal(BPBtree,RBtree));
        // tree.print();
        console.log("====================================================");
    }

    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString){
        return uint2str(_i,0);
    }

    function uint2str(uint256 _i,uint padding) internal pure returns (string memory _uintAsString){
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
}

