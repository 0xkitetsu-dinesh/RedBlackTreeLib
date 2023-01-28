// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Utils.sol";
import "../src/BokkyPooBahsRedBlackTreeLibrary.sol";
import "../src/RBTLib.sol";
contract RedBlackTest is Test {
    using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;
    using RedBlackTreeLib for RedBlackTreeLib.Tree;
    
    BokkyPooBahsRedBlackTreeLibrary.Tree BPBtree;
    RedBlackTreeLib.Tree RBtree;

    uint80 private constant EMPTY = 0;

    // function check(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,RedBlackTreeLib.Tree storage rb_tree,uint val) internal {
    //     // console.log("checking ",val);
    //     (,uint bpb_p,uint bpb_l,uint bpb_r,bool bpb_c) = bpb_tree.getNode(val);
    //     (,uint rb_p,uint rb_l,uint rb_r,bool rb_c) = rb_tree.getNode(val);

    //     // require(bpk_val == rb_val,"")
    //     require(bpb_p==rb_p,string.concat("parent mismatch ",uint2str(val)," ",uint2str(bpb_p)," ",uint2str(rb_p)));
    //     require(bpb_l==rb_l,string.concat("left mismatch ",uint2str(val)," ",uint2str(bpb_l)," ",uint2str(rb_l)));
    //     require(bpb_r==rb_r,string.concat("right mismatch ",uint2str(val)," ",uint2str(bpb_r)," ",uint2str(rb_r)));
    //     require(bpb_c==rb_c,string.concat("color mismatch ",uint2str(val)," ",bool2str(bpb_c)," ",bool2str(rb_c)));

    //     if(bpb_l == EMPTY && bpb_r == EMPTY) return;
    //     if(bpb_l != EMPTY) check(bpb_tree,rb_tree,bpb_l);
    //     if(bpb_r != EMPTY) check(bpb_tree,rb_tree,bpb_r);

    // }
    // function check(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,RedBlackTreeLib.Tree storage rb_tree,uint val) internal {
    //     // console.log("checking ",val);
    //     (,uint bpb_p,uint bpb_l,uint bpb_r,bool bpb_c) = bpb_tree.getNode(val);
    //     (,uint rb_p,uint rb_l,uint rb_r,bool rb_c) = rb_tree.getNode(val);

    //     // require(bpk_val == rb_val,"")
    //     require(bpb_p==rb_p,string.concat("parent mismatch ",uint2str(val)," ",uint2str(bpb_p)," ",uint2str(rb_p)));
    //     require(bpb_l==rb_l,string.concat("left mismatch ",uint2str(val)," ",uint2str(bpb_l)," ",uint2str(rb_l)));
    //     require(bpb_r==rb_r,string.concat("right mismatch ",uint2str(val)," ",uint2str(bpb_r)," ",uint2str(rb_r)));
    //     require(bpb_c==rb_c,string.concat("color mismatch ",uint2str(val)," ",bool2str(bpb_c)," ",bool2str(rb_c)));

    //     if(bpb_l == EMPTY && bpb_r == EMPTY) return;
    //     if(bpb_l != EMPTY) check(bpb_tree,rb_tree,bpb_l);
    //     if(bpb_r != EMPTY) check(bpb_tree,rb_tree,bpb_r);

    // }
    function equal(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,RedBlackTreeLib.Tree storage rb_tree) internal returns(bool){
        assertEq(bpb_tree.root,rb_tree.getRoot(),"root mismatch");
        if (bpb_tree.root != EMPTY){
            // check(bpb_tree,rb_tree,bpb_tree.root);
            for(uint i = 1;i<= rb_tree.totalNodes;i++){
                (uint rb_val,uint rb_p,uint rb_l,uint rb_r,bool rb_c) = rb_tree.getNodeByIndex(i);
                (uint bpb_val,uint bpb_p,uint bpb_l,uint bpb_r,bool bpb_c) = bpb_tree.getNode(rb_val);

                require(bpb_val == rb_val,"");
                require(bpb_p==rb_p,string.concat("parent mismatch ",uint2str(bpb_val)," : ",uint2str(rb_val)," :: ",uint2str(bpb_p)," : ",uint2str(rb_p)));
                require(bpb_l==rb_l,string.concat("left mismatch ",uint2str(bpb_val)," : ",uint2str(rb_val)," :: ",uint2str(bpb_l)," : ",uint2str(rb_l)));
                require(bpb_r==rb_r,string.concat("right mismatch ",uint2str(bpb_val)," : ",uint2str(rb_val)," :: ",uint2str(bpb_r)," : ",uint2str(rb_r)));
                require(bpb_c==rb_c,string.concat("color mismatch ",uint2str(bpb_val)," : ",uint2str(rb_val)," :: ",bool2str(bpb_c)," : ",bool2str(rb_c)));
            }
        }
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

    function removeRBtree(RedBlackTreeLib.Tree storage rb_tree,uint val,bool debug) internal returns(uint){
        uint tree_size = rb_tree.size();
        uint GAS_BEFORE = gasleft();
        rb_tree.remove(val);
        uint GAS_AFTER = gasleft();
        if (debug) console.log(string.concat("Tree size - ",uint2str(tree_size)," | Gas used after removing -> ",uint2str(val)),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }
    function removeBPBtree(BokkyPooBahsRedBlackTreeLibrary.Tree storage bpb_tree,uint val,bool debug) internal returns(uint){
        uint GAS_BEFORE = gasleft();
        bpb_tree.remove(val);
        uint GAS_AFTER = gasleft();
        if (debug) console.log(string.concat(" | Gas used after removing -> ",uint2str(val)),GAS_BEFORE - GAS_AFTER);
        return GAS_BEFORE - GAS_AFTER;
    }
    uint[] input_insert;
    uint[] input_delete;

    function setUp() public {
        // input_insert = [8,5,15,12,19,9,13,23,10,1];
        // input_delete = [19,5,12];
        // input_insert = [572,475,454];
        // input_delete = [572,475,454];
        uint temp = 1 ;
        for (uint i;i<1000;i++){
            temp = uint(keccak256(abi.encode(temp)));
            input_insert.push(temp);
            input_delete.push(temp);
        }
        console.log("setup",input_insert.length,input_delete.length
        //,uintArr2str(input_insert)
        );
    }

    function test() public {
        {uint gas_used_RB;uint gas_used_BPB;
        uint total_gas_used_RB;uint total_gas_used_BPB;
        console.log("============= inserting ",input_insert.length," elements (BPB,RB) =============");
        for (uint i ;i<input_insert.length;i++){
            // bool debug = i == 0 || i ==10 || i == 100 || i == 1000   ? true : false ;
            bool debug = true  ;
            gas_used_RB = insertRBtree(RBtree,input_insert[i],false);
            gas_used_BPB = insertBPBtree(BPBtree,input_insert[i],false);

            if (debug) console.log(string.concat("gas used for inserting ",uint2str(i+1,6),"th item "
                                    // ,uint2str(input_insert[i])
                                    ),gas_used_BPB,gas_used_RB , 
                                    gas_used_BPB > gas_used_RB ? string.concat("-",uint2str(((gas_used_BPB - gas_used_RB) * 100) /  gas_used_BPB),"%") : string.concat("+",uint2str(((gas_used_RB - gas_used_BPB) * 100) /  gas_used_BPB),"%")
                                    );
            total_gas_used_RB += gas_used_RB ;
            total_gas_used_BPB += gas_used_BPB ;
        }
            require(equal(BPBtree,RBtree));
        console.log(string.concat("Total gas used for inserting ",uint2str(input_insert.length)," items "),total_gas_used_BPB,total_gas_used_RB,
                    total_gas_used_BPB > total_gas_used_RB ? string.concat("-",uint2str(((total_gas_used_BPB - total_gas_used_RB) * 100) /  total_gas_used_BPB),"%") : string.concat("+",uint2str(((total_gas_used_RB - total_gas_used_BPB) * 100) /  total_gas_used_BPB),"%")
        );
        // require(equal(BPBtree,RBtree));
        // console.log("====================================================");
        }
        // RBtree.print();

        {
        uint gas_used_RB;uint gas_used_BPB;
        uint total_gas_used_RB;uint total_gas_used_BPB;

        console.log("============= removing ",input_delete.length," elements (BPB,RB) =============");
        for (uint i ;i<input_delete.length;i++){
            // bool debug = i == 0 || i ==10 || i == 100 || i == 1000  ? true : false ;
            bool debug = true;
            // if (debug) RBtree.printNode(input_delete[i]);
            gas_used_RB = removeRBtree(RBtree,input_delete[i],false);
            gas_used_BPB = removeBPBtree(BPBtree,input_delete[i],false);
            if (debug) console.log(string.concat("gas used for removing ",uint2str(i+1,6),"th item "
                                    // ,uint2str(input_delete[i])
                                    ),gas_used_BPB,gas_used_RB , 
                                    gas_used_BPB > gas_used_RB ? string.concat("-",uint2str(((gas_used_BPB - gas_used_RB) * 100) /  gas_used_BPB),"%") : string.concat("+",uint2str(((gas_used_RB - gas_used_BPB) * 100) /  gas_used_BPB),"%"));
            // RBtree.print();
            total_gas_used_RB += gas_used_RB ;
            total_gas_used_BPB += gas_used_BPB ;
            // console.log("checking ");
            // require(equal(BPBtree,RBtree));
        }
        console.log(string.concat("Total gas used for removing ",uint2str(input_delete.length)," items "),total_gas_used_BPB,total_gas_used_RB,
                    total_gas_used_BPB > total_gas_used_RB ? string.concat("-",uint2str(((total_gas_used_BPB - total_gas_used_RB) * 100) /  total_gas_used_BPB),"%") : string.concat("+",uint2str(((total_gas_used_RB - total_gas_used_BPB) * 100) /  total_gas_used_BPB),"%")
        );
        // RBtree.print();
        console.log("====================================================");
        }
    }



}

