// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/console.sol";
import "./Utils.sol";
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
    function getRoot(Tree storage self) internal view returns(uint){
        return self.nodes[self.root].value;
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
    function getNode(Tree storage self, uint value) internal view returns (uint _returnKey, uint _parent, uint _left, uint _right, bool _red) {
        // require(exists(self, value));
        uint80 key = getKey(self,value);
        require(key != EMPTY,string.concat("RBT::getNode()# NOT EXISTS ",uint2str(key)));
        // return(value, self.nodes[key].parent, self.nodes[key].left, self.nodes[key].right, self.nodes[key].red);
        return(value, self.nodes[self.nodes[key].parent].value, self.nodes[self.nodes[key].left].value, self.nodes[self.nodes[key].right].value, self.nodes[key].red);
    }
    function getNodeByIndex(Tree storage self, uint key) internal view returns (uint _returnKey, uint _parent, uint _left, uint _right, bool _red) {
        // require(exists(self, value));
        require(key != EMPTY,string.concat("RBT::getNode()# NOT EXISTS ",uint2str(key)));
        // return(value, self.nodes[key].parent, self.nodes[key].left, self.nodes[key].right, self.nodes[key].red);
        return(self.nodes[key].value, self.nodes[self.nodes[key].parent].value, self.nodes[self.nodes[key].left].value, self.nodes[self.nodes[key].right].value, self.nodes[key].red);
    }
    function exists(Tree storage self, uint value) internal view returns (bool) {
        return (value != EMPTY) && (getKey(self,value) != EMPTY);
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
        
        uint80 newNodeIdx = ++self.totalNodes;
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

    function replaceParent(Tree storage self, uint80 a, uint80 b) private {
        uint80 bParent = self.nodes[b].parent;
        self.nodes[a].parent = bParent;
        if (bParent == EMPTY) {
            self.root = a;
        } else {
            if (b == self.nodes[bParent].left) {
                self.nodes[bParent].left = a;
            } else {
                self.nodes[bParent].right = a;
            }
        } 
    }
    function removeFixup(Tree storage self, uint80 key) private {
        // console.log("removeFixup()#",key,self.nodes[key].value);
        uint80 cursor;
        while (key != self.root && !self.nodes[key].red) {
        // console.log("removeFixup()# debug 1");

            uint80 keyParent = self.nodes[key].parent;
            if (key == self.nodes[keyParent].left) {
                cursor = self.nodes[keyParent].right;
                if (self.nodes[cursor].red) {
                    self.nodes[cursor].red = false;
                    self.nodes[keyParent].red = true;
                    rotateLeft(self, keyParent);
                    cursor = self.nodes[keyParent].right;
                }
                if (!self.nodes[self.nodes[cursor].left].red && !self.nodes[self.nodes[cursor].right].red) {
                    self.nodes[cursor].red = true;
                    key = keyParent;
                } else {
                    if (!self.nodes[self.nodes[cursor].right].red) {
                        self.nodes[self.nodes[cursor].left].red = false;
                        self.nodes[cursor].red = true;
                        rotateRight(self, cursor);
                        cursor = self.nodes[keyParent].right;
                    }
                    self.nodes[cursor].red = self.nodes[keyParent].red;
                    self.nodes[keyParent].red = false;
                    self.nodes[self.nodes[cursor].right].red = false;
                    rotateLeft(self, keyParent);
                    key = self.root;
                }
            } else {
                cursor = self.nodes[keyParent].left;
                if (self.nodes[cursor].red) {
                    self.nodes[cursor].red = false;
                    self.nodes[keyParent].red = true;
                    rotateRight(self, keyParent);
                    cursor = self.nodes[keyParent].left;
                }
                if (!self.nodes[self.nodes[cursor].right].red && !self.nodes[self.nodes[cursor].left].red) {
                    self.nodes[cursor].red = true;
                    key = keyParent;
                } else {
                    if (!self.nodes[self.nodes[cursor].left].red) {
                        self.nodes[self.nodes[cursor].right].red = false;
                        self.nodes[cursor].red = true;
                        rotateLeft(self, cursor);
                        cursor = self.nodes[keyParent].left;
                    }
                    self.nodes[cursor].red = self.nodes[keyParent].red;
                    self.nodes[keyParent].red = false;
                    self.nodes[self.nodes[cursor].left].red = false;
                    rotateRight(self, keyParent);
                    key = self.root;
                }
            }
        }
        self.nodes[key].red = false;
    }

    function remove(Tree storage self, uint value) internal {
        require(value != EMPTY);
        // require(exists(self, value));
        uint80 probe;
        uint80 cursor;
        uint80 key = getKey(self,value);
        // console.log("removing ",value,key);
        if (self.nodes[key].left == EMPTY || self.nodes[key].right == EMPTY) {
            cursor = key;
        } else {
            cursor = self.nodes[key].right;
            while (self.nodes[cursor].left != EMPTY) {
                cursor = self.nodes[cursor].left; // 13
            }
            // cursor = self.nodes[key].left;
            // while (self.nodes[cursor].right != EMPTY) {
            //     cursor = self.nodes[cursor].right; // 13
            // }
        }
        if (self.nodes[cursor].left != EMPTY) {
            probe = self.nodes[cursor].left;
        } else {
            probe = self.nodes[cursor].right;
        }
        uint80 yParent = self.nodes[cursor].parent;
        self.nodes[probe].parent = yParent;
        // console.log("yParent,probe,cursor,key");
        // printNodeByIndex(self,yParent);
        // printNodeByIndex(self,probe);
        // printNodeByIndex(self,cursor);
        // printNodeByIndex(self,key);
        if (yParent != EMPTY) {
            if (cursor == self.nodes[yParent].left) {
                self.nodes[yParent].left = probe;
            } else {
                self.nodes[yParent].right = probe;
            }
        } else {
            // console.log("debugg ```````````1");
            self.root = probe;
            // print(self);
        }
        bool doFixup = !self.nodes[cursor].red;
        if (cursor != key) {
            replaceParent(self, cursor, key);
            self.nodes[cursor].left = self.nodes[key].left;
            self.nodes[self.nodes[cursor].left].parent = cursor;
            self.nodes[cursor].right = self.nodes[key].right;
            self.nodes[self.nodes[cursor].right].parent = cursor;
            self.nodes[cursor].red = self.nodes[key].red;
            (cursor, key) = (key, cursor);
        }
        if (doFixup) {
            removeFixup(self, probe);
        }
        // console.log("a4 doFixUp");
        // print(self);
        // console.log("cursor,self.totalNodes",cursor,self.totalNodes);
        uint80 last = self.totalNodes;
        Node memory lastNode = self.nodes[last];
        if (self.nodes[cursor].value != lastNode.value){

            
            self.nodes[cursor] = lastNode;
            uint80 lParent = lastNode.parent;
            // printNodeByIndex(self,last);
            // console.log("lastNode",lastNode);
            // console.log("last.parent",last.parent);
            // console.log("cursor",cursor);
            if(lastNode.parent != EMPTY){
                if (self.totalNodes == self.nodes[lParent].left){
                    self.nodes[lParent].left = cursor;
                } else {
                    self.nodes[lParent].right = cursor;
                }
            }else {
                self.root = cursor;
            }
            if (lastNode.right != EMPTY){
                self.nodes[lastNode.right].parent = cursor;
            }
            if (lastNode.left != EMPTY){
                self.nodes[lastNode.left].parent = cursor;
            }
            // console.log("b4 delete");
            // print(self);
        }
        delete self.nodes[last];
        // console.log("self.totalNodes",self.totalNodes);
        self.totalNodes--;
    }

    function print(Tree storage self) internal view {
        console.log("--------- root",self.root," totalNodes",self.totalNodes);
        uint _size = self.totalNodes;
        for(uint key;key<=_size;key++){
            console.log(string.concat(
                uint2str(key)," ",
                self.nodes[key].red ? "R" : "B"," ",
                uint2str(self.nodes[key].parent)," ",
                uint2str(self.nodes[key].left)," ",
                uint2str(self.nodes[key].right)," ",
                uint2str(self.nodes[key].value)," "
            ));
        }
        console.log("------------------");
    }

    function printNodeByIndex(Tree storage self,uint key) internal view{
        console.log(string.concat(
                uint2str(key)," ",
                self.nodes[key].red ? "R" : "B"," ",
                uint2str(self.nodes[key].parent)," ",
                uint2str(self.nodes[key].left)," ",
                uint2str(self.nodes[key].right)," ",
                uint2str(self.nodes[key].value)," "
            ));
    }
    function printNode(Tree storage self,uint val) internal view{
        uint key = getKey(self,val);
        console.log(string.concat(
                uint2str(key)," ",
                self.nodes[key].red ? "R" : "B"," ",
                uint2str(self.nodes[key].parent)," ",
                uint2str(self.nodes[key].left)," ",
                uint2str(self.nodes[key].right)," ",
                uint2str(self.nodes[key].value)," "
            ));
    }
    
}
