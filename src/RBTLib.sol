// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
library RedBlackTreeLib {
    // using LibBitmap for Tree;

    uint80 private constant EMPTY = 0;

    struct Node {
        uint256 value;
        bool red;
        uint80 parent;
        uint80 left;
        uint80 right;
    }

    struct Tree{
        uint80 root;
        uint80 totalNodes;
        mapping (uint => Node) nodes;
    }

    function size(Tree storage self) internal view returns (uint){
        return uint256(self.totalNodes);
    }

    function getKey(Tree storage self,uint value) internal view returns (uint80) {
        require(value != EMPTY,"value != EMPTY");
        uint80 probe = self.root;
        while(probe != EMPTY){
            if (value == self.nodes[probe].value){
                return probe;
                // break;
            }
            else if (value < self.nodes[probe].value){
                probe = self.nodes[probe].left;
            } else {
                probe = self.nodes[probe].right;
            }
        }
        return probe;
    }

    function exists(Tree storage self, uint value) internal view returns (bool) {
        return (value != EMPTY) && self.totalNodes != EMPTY && (getKey(self,value) != EMPTY);
        // return (value != EMPTY) && self.totalNodes != EMPTY ;
    }
    function rotateLeft(Tree storage self, uint80 key) private {
        uint80 cursor = self.nodes[key].right;
        uint80 keyParent = self.nodes[key].parent;
        uint80 cursorLeft = self.nodes[cursor].left;
        self.nodes[key].right = cursorLeft;
        if (cursorLeft != EMPTY) {
            self.nodes[cursorLeft].parent = key;
        }
        self.nodes[cursor].parent = keyParent;
        if (keyParent == EMPTY) {
            self.root = cursor;
        } else if (key == self.nodes[keyParent].left) {
            self.nodes[keyParent].left = cursor;
        } else {
            self.nodes[keyParent].right = cursor;
        }
        self.nodes[cursor].left = key;
        self.nodes[key].parent = cursor;
    }
    function rotateRight(Tree storage self, uint80 key) private {
        uint80 cursor = self.nodes[key].left;
        uint80 keyParent = self.nodes[key].parent;
        uint80 cursorRight = self.nodes[cursor].right;
        self.nodes[key].left = cursorRight;
        if (cursorRight != EMPTY) {
            self.nodes[cursorRight].parent = key;
        }
        self.nodes[cursor].parent = keyParent;
        if (keyParent == EMPTY) {
            self.root = cursor;
        } else if (key == self.nodes[keyParent].right) {
            self.nodes[keyParent].right = cursor;
        } else {
            self.nodes[keyParent].left = cursor;
        }
        self.nodes[cursor].right = key;
        self.nodes[key].parent = cursor;
    }

    function insertFixup(Tree storage self, uint80 key) private {
        uint80 cursor;
        while (key != self.root && self.nodes[self.nodes[key].parent].red) {
            uint80 keyParent = self.nodes[key].parent;
            if (keyParent == self.nodes[self.nodes[keyParent].parent].left) {
                cursor = self.nodes[self.nodes[keyParent].parent].right;
                if (self.nodes[cursor].red) {
                    self.nodes[keyParent].red = false;
                    self.nodes[cursor].red = false;
                    self.nodes[self.nodes[keyParent].parent].red = true;
                    key = self.nodes[keyParent].parent;
                } else {
                    if (key == self.nodes[keyParent].right) {
                      key = keyParent;
                      rotateLeft(self, key);
                    }
                    keyParent = self.nodes[key].parent;
                    self.nodes[keyParent].red = false;
                    self.nodes[self.nodes[keyParent].parent].red = true;
                    rotateRight(self, self.nodes[keyParent].parent);
                }
            } else { // if keyParent on right side
                cursor = self.nodes[self.nodes[keyParent].parent].left;
                if (self.nodes[cursor].red) {
                    self.nodes[keyParent].red = false;
                    self.nodes[cursor].red = false;
                    self.nodes[self.nodes[keyParent].parent].red = true;
                    key = self.nodes[keyParent].parent;
                } else {
                    if (key == self.nodes[keyParent].left) {
                      key = keyParent;
                      rotateRight(self, key);
                    }
                    keyParent = self.nodes[key].parent;
                    self.nodes[keyParent].red = false;
                    self.nodes[self.nodes[keyParent].parent].red = true;
                    rotateLeft(self, self.nodes[keyParent].parent);
                }
            }
        }
        self.nodes[self.root].red = false;
    }

    function insert(Tree storage self, uint value) internal {
        // console.log("inserting",value);
        require(value != EMPTY,"value != EMPTY");
        require(!exists(self,value),"No Duplicates! ");
        uint80 cursor = EMPTY;
        uint80 probe = self.root;
        // print(self);

        while(probe != EMPTY){
            cursor = probe;
            if (value < self.nodes[probe].value){
                probe = self.nodes[probe].left;
            } else {
                probe = self.nodes[probe].right;
            }
        }
        
        uint80 newNodeIdx = 1;
        // console.log("newNodeIdx ",newNodeIdx);
        self.nodes[newNodeIdx] = Node({value:value,red:true,parent: cursor, left: EMPTY, right: EMPTY});
        if (cursor == EMPTY) {
            self.root = newNodeIdx;
        } else if (value < self.nodes[cursor].value){
            self.nodes[cursor].left = newNodeIdx;
        } else {
            self.nodes[cursor].right = newNodeIdx;
        }
        // print(self);
        // console.log("insert ended",value);
        insertFixup(self, newNodeIdx);
    }

    function print(Tree storage self) internal view {
        console.log("--------- root",self.root);
        uint idx = self.totalNodes;
        for(uint key;key<=idx;key++){
            console.log(string.concat(
                uint2str(key)," ",
                self.nodes[key].red ? "R" : "B"," ",
                uint2str(self.nodes[key].value)," ",
                uint2str(self.nodes[key].parent)," ",
                uint2str(self.nodes[key].left)," ",
                uint2str(self.nodes[key].right)," "
            ));
        }
        console.log("------------------");
    }


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
